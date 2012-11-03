Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA31tbrP227573 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 20:55:37 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	SPTDcHdiGKidTxYb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 18:57:30 -0700 (PDT)
Received: by mail-vc0-f181.google.com with SMTP id n11so4803296vch.26
	for <xfs@oss.sgi.com>; Fri, 02 Nov 2012 18:57:29 -0700 (PDT)
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard> <34630253.post@talk.nabble.com>
	<20121102012728.GT29378@dastard> <34633803.post@talk.nabble.com>
	<20121102225509.GZ29378@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121102225509.GZ29378@dastard>
Message-Id: <37CBCD87-5B71-4B9C-8FAE-5BBF85804983@gmail.com>
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
Date: Fri, 2 Nov 2012 21:57:27 -0400
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dave,


> 
> 0x780dbd80007f248
> 
> Once again it's corruption in the upper 32 bits of the 64 bit number.
> Those bits should be zero. Perhaps looking at all the trace events
> from recovery might give you a closer approximation of where the bad
> extent records is found....

I have been trying to use the xfs_db xfs_logprint, how ever xfs_logprint bails out when it finds an error. 
How do I look at trace events ?.


Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
