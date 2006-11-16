Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 14:56:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGMuSaG026715
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:56:29 -0800
Message-ID: <455CEC68.9000401@sandeen.net>
Date: Thu, 16 Nov 2006 16:55:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <20061116224527.GF11034@melbourne.sgi.com>
In-Reply-To: <20061116224527.GF11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:

> The real bug here was whoever removed the dummy field and did not
> replace that with a comment ot say that the xfs_sb strucutre needs
> to be padded to 64 bits to ensure translation worked properly
> on 64 bit systems.
> 
> I'd prefer explicit padding (with warning comments) over packing
> the structure. Thoughts?

yes, I agree that explicit padding, and a comment about why it's there,
would be better.

I was thinking about this over lunch and meant to follow up, but then
figured out that the actual bug isn't because of this (it's broken as
well on x86), and kept trying to chase that :)

-Eric
