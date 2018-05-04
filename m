Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54406 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbeEDWdh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 18:33:37 -0400
Subject: Re: [PATCH 09/11] xfs_repair: don't assert if we run across a dir
 entry with null ino ptr
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401964787.13319.7143262291746238151.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <724f18e7-147d-4c24-ba06-559a5b057e4f@sandeen.net>
Date: Fri, 4 May 2018 17:33:35 -0500
MIME-Version: 1.0
In-Reply-To: <152401964787.13319.7143262291746238151.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we encounter a directory with an entry that points to inode zero,
> we'll crash due to an ASSERT during process_inode_chunk.  Instead, just
> set the in-core parent to NULLFSINO so that phase 6 will reset it for
> us.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

So .... this is .... probably ok?  but the ASSERT makes me think that
process_dinode is never supposed to return a 0 parent if isa_dir is set,
and so I'm a little worried about breaking that assumption up and just
catching it later, here.  Usually the asserts mean "the code should never
let this happen and if it does, some prior code is wrong"

Looking at the calls below it, it seems like we generally call verify_inum
which would set NULLFSINO if the inum is bad.

But in process_dir2_data

[17:25]  <sandeen>                 } else if (verify_inum(mp, ent_ino)) {
[17:25]  <sandeen>                         clearreason = _("invalid");
[17:26]  <sandeen> so we probably saw that it's bad, but:
[17:26]  <sandeen>                  * We have a special dot & dotdot fixer-upper below which can
[17:26]  <sandeen>                  * sort out the proper inode number, so don't clear it.
[17:26]  <sandeen>                         clearreason = NULL;
[17:26]  <sandeen> and then:
[17:26]  <sandeen>                  * Special .. entry processing.
[17:26]  <sandeen>                                 *parent = ent_ino;
[17:26]  <sandeen> \o/

so ... I wonder if it wouldn't be more consistent to find the place under
process_inode() where we willingly/wrongly set *parent to an invalid value,
and handle the problem there?  Do you know what path you were on to hit this?

-Eric
> ---
>  repair/dino_chunks.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 17de95f..2d34079 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -874,7 +874,8 @@ process_inode_chunk(
>  			 * be solid then.
>  			 */
>  			if (!ino_discovery)  {
> -				ASSERT(parent != 0);
> +				if (parent == 0)
> +					parent = NULLFSINO;
>  				set_inode_parent(ino_rec, irec_offset, parent);
>  				ASSERT(parent ==
>  					get_inode_parent(ino_rec, irec_offset));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
