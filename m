Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 19:51:21 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N2pDqM019585
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 19:51:14 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, RFC] Re: atime not written to disk
References: <48FD74CC.907@sgi.com> <48FD7B69.3090600@wm.jp.nec.com>
	<20081022081710.GL18495@disturbed>
Date: Thu, 23 Oct 2008 13:52:44 +1100
In-Reply-To: <20081022081710.GL18495@disturbed> (Dave Chinner's message of
	"Wed, 22 Oct 2008 19:17:10 +1100")
Message-ID: <nccvdvknhtv.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs <xfs@oss.sgi.com>

Dave Chinner <david@fromorbit.com> writes:
[...]
> As I mentioned on IRC, Tim, the following patch fixes the above test
> case. It will make XFS behave like other filesystems w.r.t. atime,
> instead of defaulting to relatime-like behaviour. This will have
> performance impact unless ppl now add the relatime mount option.
 ^^^^^^^^^^^^^^^^^^^

I don't really like it, and don't think there is a real justification to
do it. Why not only do:

-- 
Niv Sardi
