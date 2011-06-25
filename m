Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5PLgdHV147100 for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 16:42:40 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D7472E70A
	for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 14:42:38 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id t3mm3s28ohLx5Bug
	for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 14:42:38 -0700 (PDT)
Received: from speechless.lan.dermichi.com
	([2001:470:26:2a9:4a5b:39ff:fe18:7163])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1Qaacd-0000zE-1T
	for xfs@oss.sgi.com; Sat, 25 Jun 2011 23:42:35 +0200
Message-ID: <4E065648.4070904@dermichi.com>
Date: Sat, 25 Jun 2011 23:42:32 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore seems to hang
References: <87oc1ln8xx.fsf@psinom.home> <87iprtn4s9.fsf@psinom.home>
In-Reply-To: <87iprtn4s9.fsf@psinom.home>
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

Hi Prad!
> 
> so is it possible that the xfsrestore system has to go through the
> motion of handling the entire file even when it's just extracting a
> small part of it and things will take their time?
> 
Yes, that's simply the way it works. It has to go through the whole dump
to restore one file. Same thing as if you used tar. Both were originally
designed to be written to tape. So if you want to restore single files
you should look for another solution. I like to use rsync a lot for that.

cheers,
michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
