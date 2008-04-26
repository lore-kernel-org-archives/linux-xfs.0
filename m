Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 13:01:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QK1a0D024892
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:01:37 -0700
Received: from smtp-out04.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8013815EDC54
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:02:18 -0700 (PDT)
Received: from smtp-out04.alice-dsl.net (smtp-out04.alice-dsl.net [88.44.63.6]) by cuda.sgi.com with ESMTP id nbSJHCsyXqSZiYnH for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:02:18 -0700 (PDT)
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Andi Kleen <andi@firstfloor.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
Date: Sat, 26 Apr 2008 22:02:17 +0200
In-Reply-To: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> (Denys Vlasenko's message of "Sat, 26 Apr 2008 16:51:02 +0200")
Message-ID: <87iqy4wfjq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:
>
> Compile tested only.

You should mark the helper noinline just to prevent gcc from possibly
inlining it. Even if it doesn't with your current compiler inline heuristics
vary widely between compiler versions.

-Andi
