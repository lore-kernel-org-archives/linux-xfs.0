Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54B917F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:36:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43CC2304032
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:36:01 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id Tqil2ipCMgzViZVT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:35:58 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id A4F1D20B03
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:35:57 +0100 (CET)
Date: Tue, 12 Jan 2016 22:33:22 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160112213322.GA10558@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan> <20160112212454.GM10456@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112212454.GM10456@dastard>
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
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Jan 12, 2016 at 08:59:45PM +0100, Felix Janda wrote:
> > ustat has been used to check whether a device file is mounted.
> > The function is deprecated and not supported by uclibc and musl.
> > Now do the check using the *mntent functions.
> 
> Which will cause problems with builds on other platforms.

This is the linux specific code...

>  Why not
> just use statfs() instead?

Since it does not have the functionality which ustat is used for.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
