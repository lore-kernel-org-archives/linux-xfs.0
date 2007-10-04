Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 09:52:58 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94GqqDr031750
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 09:52:55 -0700
Received: by wa-out-1112.google.com with SMTP id k22so297554waf
        for <xfs@oss.sgi.com>; Thu, 04 Oct 2007 09:52:52 -0700 (PDT)
Message-ID: <cc7060690710040952q342cf3fct20f523fb0fbdda3d@mail.gmail.com>
Date: Thu, 4 Oct 2007 09:52:52 -0700
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: Reading directory entries from BMAP
In-Reply-To: <13040897.post@talk.nabble.com>
MIME-Version: 1.0
References: <13040897.post@talk.nabble.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cyjoyp <cyjoyp@gmail.com>
Cc: xfs@oss.sgi.com

br_startoff is starting offset of a file. The problem you are facing is not
clear to me.
XFS uses 16 bytes to represet start offset, length of the extent and then
start bloock
offset.

If you are interested with directories of XFS, the blocks that start from 0
offset and with
in the file address space of 32GB is the name space. After name space, you
have
lookup space and then free space manager for directories. Typically, reading
of
directory entries is reading of the total blocks reported by stat command. A
directory
can be in single block format, embedded in the inode itself, etc.

You are talking about bmbt_irec and then going towards directory entries.
This was
 not clear to me.

-Saradhi.

On 10/4/07, cyjoyp <cyjoyp@gmail.com> wrote:
>
>
> Hi there,
>           I am a beginner in learning XFS file system.. I have a doubt,
> dont
> know whether is silly..If you could help me with this...Thank you..
>
>    An extent is 128 bit in size and uses the following struct,
>
>         typedef struct xfs_bmbt_irec {
>                       xfs_fileoff_t              br_startoff;
>                       xfs_fsblock_t            br_startblock;
>                       xfs_filblks_t              br_blockcount;
>                       xfs_exntst_t             br_state;
>                      }
>
>      I have got in to the BMAP position after traversing the BTREE..
>      The BMAP has a leaf and no other siblings..
>      I have the extents for directory entries stored in the BMAP..
>      This is where is struck badly..
>
>     Now I have a 16 byte value from which I can calculate the block count
> ,AG number ,etc...
>              00 00 00 01 00 00 02 00 00 00 00 00 02 A0 00 02
>    In this case I lan up some where else instead going to the block of
> directory entries..
>    This br_startoff (logical offset) is causing a difference...I am going
> wrong somwhere in this case..
>
>
>      Could you please tell me br_startoff does really mean???
>
>
>
>
>
>
>
>
>
>
>
> --
> View this message in context:
> http://www.nabble.com/Reading-directory-entries-from-BMAP-tf4569129.html#a13040897
> Sent from the Xfs - General mailing list archive at Nabble.com.
>
>
> [[HTML alternate version deleted]]
>
>
>


[[HTML alternate version deleted]]
