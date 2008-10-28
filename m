Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:11:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S7BoPd028379
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:11:51 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4B0C54ED93
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:11:49 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id RkruxnDihSeXMJAg for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:11:49 -0700 (PDT)
Message-ID: <4906BB32.8080403@aei.mpg.de>
Date: Tue, 28 Oct 2008 08:11:46 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed>
In-Reply-To: <20081027233516.GG4985@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Soltys <nozo@drutsystem.com>, david@fromorbit.com, xfs@oss.sgi.com

Hi Dave et al

Dave Chinner wrote:

> Blockget - yes it will. It just does the traversal internally to
> build the mapping. With large filesystems xfs_db can run out of
> memory building the mapping, which is why I've used the
> explicit traverse+xfs_bmap method in the past....

How expensive is this operation (rule of thumb)? We will mostly use this
on compute nodes where the partition is 500-750 GB large and the node
has 8 GB of memory. For the simple test where I apparently hit thin air
I have not seen anything bad in terms of memory consumption.

Cheers

Carsten
