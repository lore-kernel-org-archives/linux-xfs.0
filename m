Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 15:24:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m32MNodH006515
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 15:23:52 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B0B0730A6B
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 15:24:25 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id hnBAH6MHZKYTIufW for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 15:24:25 -0700 (PDT)
Date: Thu, 3 Apr 2008 00:22:48 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080403002248.4bd263e6@galadriel.home>
In-Reply-To: <20080402220750.GJ103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
	<20080325233611.GW103491721@sgi.com>
	<20080401140035.46470306@galadriel.home>
	<20080402055831.GG103491721@sgi.com>
	<20080402133003.4bb043e4@galadriel.home>
	<20080402220750.GJ103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Thu, 3 Apr 2008 08:07:50 +1000 vous écriviez:

> I'd go and find whatever disk is located at LBA 0xE6DCA-0xE6E2A and
> replace it - if there are that many repairs needed on it, it's likely
> to be failing....
> 

Oh, it failed  and I changed it. However it's a RAID-5 and though it
appeared corrected, as you've seen the XFS fs crashed for no apparent
reason (there was little or no activity at the time of the march 23rd
crash) later. I was wondering if it could be related, for instance if
some garbage may have remained hidden somewhere and break it later,
like a standing nail waiting for someone to step on it...


-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
