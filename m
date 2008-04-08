Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 21:42:54 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m384gkhS004063
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 21:42:47 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [patch] xfsqa 185 - remove uninitialised variables in golden output.
In-Reply-To: <20080408014023.GO108924158@sgi.com> (David Chinner's message of
	"Tue, 8 Apr 2008 11:40:23 +1000")
References: <20080408014023.GO108924158@sgi.com>
Date: Tue, 08 Apr 2008 14:43:15 +1000
Message-ID: <nccr6dhhs7w.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:

> Kill the output of uninitialised values when punching a hole.
> This prevents the test from passing on just about everything.
>
> Signed-off-by: Dave Chinner <dgc@sgi.com>

Thanks dave, I've been meaning to do that for a long time, we might want
to kill the sid output too when it's not specified on command line (can
that change ? I've always seen it as 0).

Cheers,
-- 
Niv Sardi
