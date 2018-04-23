Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:39499 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754306AbeDWJLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 05:11:38 -0400
Received: by mail-wr0-f173.google.com with SMTP id q3-v6so29067947wrj.6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 02:11:38 -0700 (PDT)
Date: Mon, 23 Apr 2018 11:11:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is
 not recognized
Message-ID: <20180423091135.qaswj5adgvt2tfqk@odin.usersys.redhat.com>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <20180418154435.GQ24738@magnolia>
 <20180419091302.coz4clrmr5ubdku2@odin.usersys.redhat.com>
 <20180419200126.GB24738@magnolia>
 <74cfae6a-71d0-dace-f4f0-64d939acb5e3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74cfae6a-71d0-dace-f4f0-64d939acb5e3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 03:18:12PM -0500, Eric Sandeen wrote:
> On 4/19/18 3:01 PM, Darrick J. Wong wrote:
> 
>  
> > I like it better, though on further thought I think I like better the
> > idea of printing the contents of all potential magic numbers:
> > 
> > For a block starting with:
> > 
> > 0xDE 0xAD 0xBE 0xEF 0xCA 0xFE 0xF0 0x0D 0xBA 0xAD...
> > 
> > xfs_db> p
> > Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
> > unknown.blockhdr.magic = 0xDEADBEEF
> > unknown.da_blkinfo.magic = 0xBAAD
> > unknown.inode.magic = 0xDEAD
> 
> If we asked for an attr3 type, I don't see the value in printing out structures
> that are unrelated to an attr3, like an inode....?
> 

Well, if we fall into this case, the block is supposed to have no attr3 relevant
fields at all, so, I don't see how we would benefit from printing 'relevant'
attr3 data from a non attr3 block.

Although I also didn't like the idea of being 'specific' on the magic number
type, because we don't know what we would be printing, unless we do some checks
and see if we could match the block with a known type, which well, although I
think it's doable, I don't see it being too useful at all.

Best case scenario, we try to print a non-attr3 type using attr3, and a
'generic' attempt to print a magic number using both blkinfo style offset, and
remote style offset, would be enough. As the main reason here is to tell the
user "hey, you are using attr3 on the wrong place", and let the user correct it.
After all, xfs_db users are supposed to know what they are doing.

Worst case scenario is trying to print a corrupted block, which well, no matter
what we print, it's not gonna make sense anyway.

/me starts to think if just printing an "unrecognized format" message isn't the
best approach after all :P


> The whole problem here is that "attr3" is non-specific, and could be several
> formats.  (bad design decision, IMHO, but bridge, water under, etc).  So I'd
> prefer that we only print structures which might be relevant to the thing(s)
> the user asked for.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
