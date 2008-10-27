Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 05:32:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RCWCu3015692
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:32:14 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA8FADE314
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:32:09 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id F6U9tVhHAzhdxA3Y for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 05:32:09 -0700 (PDT)
Message-ID: <4905B48A.8010108@aei.mpg.de>
Date: Mon, 27 Oct 2008 13:31:06 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed>
In-Reply-To: <20081027114945.GE4985@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>, xfs@oss.sgi.com

Hi Dave (and Peter)

Dave Chinner wrote:
> Use xfs_bmap to find the location on disk of the extents in each
> file. Recurse over the filesystem until you find the file that owns
> the block that went bad.

Sounds like a tedious but doable route to take.

Thanks for the quick reply!

Carsten
