Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8071E7CA0
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 09:26:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43FF7304053
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 07:26:10 -0700 (PDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id SwsVXYfdfY6oK1f1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2016 07:26:07 -0700 (PDT)
Received: by mail-wm0-f44.google.com with SMTP id q128so320436353wma.1
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 07:26:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729022552.GA16044@dastard>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
	<CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
	<20160729022552.GA16044@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 30 Jul 2016 17:26:03 +0300
Message-ID: <CAOQ4uxiJ9yNyJhyEoTPrqJ0F-HcJz6hagio1K_pxVPPQiDC=KQ@mail.gmail.com>
Subject: Re: Any better way to interact with xfs?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ryan Lindsay <rlindsay@unimelb.edu.au>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jul 29, 2016 at 5:25 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 28, 2016 at 09:48:07AM +0300, Amir Goldstein wrote:
>> Hi Ryan,
>>
>> You could use the XFS_IOC_FSINUMBERS/XFS_IOC_FSBULKSTAT API to iterate
>> over all inodes in the fs.
>
> That's a read-only API - you can't use it to change the inodes
> on disk.
>
>> not having to readdir and recourse the directory tree should safe you
>> some time (much less i/o).
>> Also, the interface can be used to make your conversion work parallel
>> by working on different inode ranges.
>
> It cannot be used to make coherent, atomic changes to the inode
> state.
>

I'm curios: In theory, one can construct a file_handle from bulkstat
info. correct?
and one could use that handle to open_by_handle_at() and fchown(). right?
I realize that both APIs were not intended for this use case, but I wonder:
1. can it be done?
2. what are the possible consequences?
3. what do you mean by "coherent, atomic changes to the inode state"?
does it not play well with the dentry/inode cache?

>> You can use xfsdump/xfsrestore code as reference.
>
> xfsdump uses bulkstat scan and read inodes, not change anything on
> disk.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
