Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2GWetR151844 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 11:32:40 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id vJU3sAmzNRx1UC9i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 09:34:32 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1TUKCW-00022s-1b
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 09:34:32 -0700
Message-ID: <34633803.post@talk.nabble.com>
Date: Fri, 2 Nov 2012 09:34:32 -0700 (PDT)
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
In-Reply-To: <20121102012728.GT29378@dastard>
MIME-Version: 1.0
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard> <34630253.post@talk.nabble.com>
	<20121102012728.GT29378@dastard>
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
To: xfs@oss.sgi.com


Dave,

I see the following. On two different systems with the same want= value.
Does not seem like a random corruption.

>attempt to access beyond end of device
> sda2: rw=0, want=33792081130943048, limit=3147132

> > Track down where those stray upper bits in the block numbers are
> > coming from, and you'll have your answer. 

Where would be the best place to put this check. 

Also on a XFS DEBUG all the asserts seem to be in the unlink (delete path).


Kamal

-- 
View this message in context: http://old.nabble.com/xfs-filesystem-corruption-with-kernel-2.6.37-tp34601185p34633803.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
