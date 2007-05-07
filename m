Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 03:07:59 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47A7tfB005622
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 03:07:56 -0700
Date: Mon, 7 May 2007 12:07:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070507120754.289deffd@galadriel.home>
In-Reply-To: <20070507021122.GQ32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com>
	<20070504005922.GC32602149@melbourne.sgi.com>
	<20070504090613.7c0f97d3@galadriel.home>
	<20070504073344.GL32602149@melbourne.sgi.com>
	<20070504152546.614374ac@harpe.intellique.com>
	<20070507021122.GQ32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Mon, 7 May 2007 12:11:22 +1000 vous écriviez:

> So you use software raid and you get corruptions, right? I doubt this
> has anything to do with write barriers - if it does thats an
> indication of broken drivers or hardware.....
> 
> Can you run with "-o nobarrier" and no software raid and see if you
> still have a problem?

I tried on the same machine without software RAID and barriers, and i
worked OK. I'll try today with nobarrier. Stay tuned :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
