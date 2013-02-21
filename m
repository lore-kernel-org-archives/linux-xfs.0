Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 459587F51
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 05:27:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3E6BAC008
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:27:40 -0800 (PST)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id fSFXut6aUbNJaFx2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:27:39 -0800 (PST)
Received: by mail-wg0-f54.google.com with SMTP id fm10so7506215wgb.9
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:27:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935@NDA-HCLT-MBS02.hclt.corp.hcl.in>
References: <4DF92F995A2E4C48ABADDA7F8E05A63D09BE1935@NDA-HCLT-MBS02.hclt.corp.hcl.in>
Date: Thu, 21 Feb 2013 12:27:38 +0100
Message-ID: <CAAxjCEzbE=rjXPZkmCZ=JeSHr1VjRR+36-iBWNWL04+NaoSRjg@mail.gmail.com>
Subject: Re: XFS_DB
From: Stefan Ring <stefanrin@gmail.com>
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
To: Anshul Kundra <anshul.kundra@hcl.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Instead of accessing the device itself can we read the metadump file to get
> the required information of file mapping with file system block number. Its
> binary file but is there any utility which reads the metadump file itself
> instead of file system image. As it is easier to read the metadump file
> instead of go towards  disk access itself. There is file obfuscation in the
> file name for 4 characters

IIRC, a metadump can be "restored" into a sparse file that does not
require much more space than the metadump itself.

> On finding out solution over the OOM I found reference of xfs_db 64  but
> there is no 64 bit version of utility available in xfs website either there
> will be some configuration option or it becomes obsolete.

Are you using Linux? On every 64 bit Linux the XFS binaries are built in 64 bit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
