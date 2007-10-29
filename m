Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 08:07:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TF7Qla000464
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 08:07:27 -0700
Message-ID: <4725F732.2060509@sandeen.net>
Date: Mon, 29 Oct 2007 10:07:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725E84D.3030609@sandeen.net> <4725F6C0.3020303@theendofthetunnel.de>
In-Reply-To: <4725F6C0.3020303@theendofthetunnel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

Hannes Dorbath wrote:
> On 29.10.2007 15:03, Eric Sandeen wrote:
>> Niv Sardi wrote:
>>> XFS's default mount options are in most cases sub-optimal, we should try
>>> to have more sensible defaults, so far I'm following some quick dave-powered
>>> recomendations:
> 
> Is there any reason to not set the default inode size to 512 bytes? ..as 
> suggested in:
> 
> http://www.suse.de/~agruen/acl/linux-acls/online/

attr2 should help with the problem now... unless there is some common
case where attr2+256 still spills out a lot?

-Eric
