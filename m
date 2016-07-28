Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95F657CA0
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 01:48:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 543798F8037
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 23:48:11 -0700 (PDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id rpCECO2OOhbgQxBP
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2016 23:48:09 -0700 (PDT)
Received: by mail-wm0-f50.google.com with SMTP id f65so238955251wmi.0
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 23:48:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 28 Jul 2016 09:48:07 +0300
Message-ID: <CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
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
To: Ryan Lindsay <rlindsay@unimelb.edu.au>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ryan,

You could use the XFS_IOC_FSINUMBERS/XFS_IOC_FSBULKSTAT API to iterate
over all inodes in the fs.
not having to readdir and recourse the directory tree should safe you
some time (much less i/o).
Also, the interface can be used to make your conversion work parallel
by working on different inode ranges.
You can use xfsdump/xfsrestore code as reference.
Also, not sure if you are using user/group quotas - if you don't,
better make sure that quotas are turned off
to avoid all the accounting caused by your conversion process.

Amir.

On Thu, Jul 28, 2016 at 6:30 AM, Ryan Lindsay <rlindsay@unimelb.edu.au> wrote:
> Hi
>
> I have a bit of a specific requirement.
>
> I have a server that currently has a 12T worth of data on it on an xfs
> formatted LV.
>
> currently the file permissions are set via an LDAP, however we are having to
> move to AD for out authentication mechanism. Which will change the value of
> the existing UID's and GID's
>
> Since XFS has a lot of mechanisms that allow things to happen in parallel. I
> was wondering if there was a way of interacting at the file system level to
> facilitate a change of UID's on files rather than having to just chown
> recursively down the file system. The faster I can update the permissions
> the better basically
>
>
> Ryan Lindsay | Research Infrastructure Lead
>
> Faculty of Science IT
> Room G09, Old Geology Bld, University of Melbourne, 3010, VIC
> Telephone +61 3 83446255 | Mobile +61 0407537949 | Email
> rlindsay@unimelb.edu.au
>
> This email and any attachments may contain personal information or
> information that is otherwise confidential or the subject of copyright. Any
> use, disclosure or copying of any part of it is prohibited. The University
> does not warrant that this email or any attachments are free from viruses or
> defects. Please check any attachments for viruses and defects before opening
> them. If this email is received in error please delete it and notify us by
> return email.
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
