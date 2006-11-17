Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 23:47:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAH7kuaG024458
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 23:46:58 -0800
Received: from page.mel.office.aconex.com (mail.aconex.com [150.101.159.26])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB118D1D702C
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 23:46:07 -0800 (PST)
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
References: <455CB54F.8080901@sandeen.net>
	 <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
	 <20061117023946.GN11034@melbourne.sgi.com>
	 <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
	 <20061117055521.GS11034@melbourne.sgi.com>
	 <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
Content-Type: text/plain
Date: Fri, 17 Nov 2006 17:52:23 +1100
Message-Id: <1163746343.4695.152.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Fri, 2006-11-17 at 00:34 -0600, sandeen@sandeen.net wrote:
> and really, now that this is out in the wild, maybe sb_features3
> instead of padding is appropriate, and check both for the attr2
> bit...? :(

Thats not going to work, theres three or four other feature2 bits
preceding attr2 as well.

The "take a 32 bit systems fs to a 64 bit system" is relatively
uncommon, so I suppose its just something we live with (as we did
with the log recovery issues in that situation for several years).

cheers.

-- 
Nathan
