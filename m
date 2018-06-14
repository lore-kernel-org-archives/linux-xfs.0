Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41360 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964834AbeFNWU5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 18:20:57 -0400
Subject: Re: [PATCH] xfs_repair: Fix root inode's parent when it's bogus for
 sf directory
References: <20180614221646.20017-1-mbenatto@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1ddae533-b040-fdba-4350-01b59d5ddcba@sandeen.net>
Date: Thu, 14 Jun 2018 17:20:56 -0500
MIME-Version: 1.0
In-Reply-To: <20180614221646.20017-1-mbenatto@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco Benatto <mbenatto@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 6/14/18 5:16 PM, Marco Benatto wrote:
> Currently when root inode is in short-form and its parent ino
> has an invalid value, process_sf_dir2() ends up not fixing it,
> because if verify_inum() fails we never get to the next case which
> would fix the root inode's parent pointer.
> 
> This behavior triggers the following assert on process_dir2():
> 
>    ASSERT((ino != mp->m_sb.sb_rootino && ino != *parent) ||
>         (ino == mp->m_sb.sb_rootino &&
>         (ino == *parent || need_root_dotdot == 1)));
> 
> This patch fixes this behavior by making sure we always properly
> handle rootino parent pointer in process_sf_dir2()
> 
> Signed-off-by: Marco Benatto <mbenatto@redhat.com>

This looks correct to me, thanks.

FWIW the problem can be demonstrated by setting the root inode's
parent to 0 on a freshly made fs:

# mkfs.xfs -f -dfile,name=fsfile,size=1g
# xfs_db -x -c "sb 0" -c "addr rootino" -c "write u3.sfdir3.hdr.parent.i4 0" fsfile
# xfs_repair fsfile

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dir2.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index e162d2b..225f926 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -495,8 +495,10 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
>  
>  	/*
>  	 * if parent entry is bogus, null it out.  we'll fix it later .
> +	 * If the validation fails for the root inode we fix it in
> +	 * the next else case.
>  	 */
> -	if (verify_inum(mp, *parent))  {
> +	if (verify_inum(mp, *parent) && ino != mp->m_sb.sb_rootino)  {
>  
>  		do_warn(
>  _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
> 
