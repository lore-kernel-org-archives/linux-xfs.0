Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Oct 2006 21:26:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9N4QaaG003985
	for <xfs@oss.sgi.com>; Sun, 22 Oct 2006 21:26:39 -0700
Date: Mon, 23 Oct 2006 14:26:07 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs_ncheck gives outdated and partial result
Message-ID: <C87D713C7D1338DB3D8FC45A@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <200610200858.08718.daniele@interline.it>
References: <200610200858.08718.daniele@interline.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>, xfs@oss.sgi.com



--On 20 October 2006 8:58:08 AM +0200 "Daniele P." <daniele@interline.it> wrote:

> Hi All,
> I'm here to ask a couple of question regarding xfs_ncheck.
> I'm using xfs_db version 2.6.20
>
...
> And why it's print only the first file name for inodes pointed
> by multiple files (2)?
>

I presume you are referring to hardlinks - with multiple directory
entries pointing to the same inode.
Looking at db/check.c/addname_inode() it looks like it only stores
the first name that it comes across during directory processing when
scanning happens in the blockget command.


addname_inode(
        inodata_t       *id,
        char            *name,
        int             namelen)
{
        if (!nflag || id->name)  <---- if name exists, then return
                return;
        id->name = xmalloc(namelen + 1);
        memcpy(id->name, name, namelen);
        id->name[namelen] = '\0';
}

So we just get one valid path.

--Tim
