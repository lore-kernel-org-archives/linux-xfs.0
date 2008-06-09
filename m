Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jun 2008 20:30:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m593UsUp010343
	for <xfs@oss.sgi.com>; Sun, 8 Jun 2008 20:30:54 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D212AC565FE
	for <xfs@oss.sgi.com>; Sun,  8 Jun 2008 20:31:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id FbRvyiIC497OGmcW for <xfs@oss.sgi.com>; Sun, 08 Jun 2008 20:31:49 -0700 (PDT)
Message-ID: <484CA425.3080606@sandeen.net>
Date: Sun, 08 Jun 2008 22:31:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams
References: <484B15A3.4030505@sauce.co.nz>
In-Reply-To: <484B15A3.4030505@sauce.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

Richard Scobie wrote:
> Is my understanding of filestreams correct, in that files written to a 
> particular filestreams enabled directory are all allocated to 1 ag as 
> long as the filestreams timeout is not exceeded - which I believe is 30s?
> 
> In other words, if I copy 100 files into a directory, (cp -a 
> dir_containing_100_files dest_dir), wait 60 seconds and do (cp -a 
> dir_containing_100_different_files dest_dir), each directory and 
> contents in dest_dir will be stored in a single, different ag?
> 
> Also, would it be possible for the filestreams parameter to be added to 
> man pages/kernel docs?

Yes please :)  I was just noticing last week that there is no
documentation anywhere on this feature ....

-Eric

> Thanks,
> 
> Richard
> 
> 
