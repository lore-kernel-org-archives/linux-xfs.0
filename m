Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:03:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RD3brL018147
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:37 -0700
Received: from relay.ppgk.com.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E656612AD915
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:36 -0700 (PDT)
Received: from relay.ppgk.com.pl (relay.ppgk.com.pl [80.53.243.36]) by cuda.sgi.com with ESMTP id VhqbNeF9T6eGPEAb for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:36 -0700 (PDT)
Message-ID: <4905BC13.3030402@drutsystem.com>
Date: Mon, 27 Oct 2008 14:03:15 +0100
From: Michal Soltys <nozo@drutsystem.com>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de>
In-Reply-To: <4905B48A.8010108@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

Carsten Aulbert wrote:
> 
> Dave Chinner wrote:
>> Use xfs_bmap to find the location on disk of the extents in each
>> file. Recurse over the filesystem until you find the file that owns
>> the block that went bad.
> 
> Sounds like a tedious but doable route to take.
> 

Wouldn't something like (under xfs_db) :

getblock -b #block -n
ncheck -i #inode

where required #inode is reported by getblock

do the thing ?
