Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 00:13:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m627DKs2025195
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 00:13:22 -0700
Message-ID: <486B2ACA.2050506@sgi.com>
Date: Wed, 02 Jul 2008 17:14:18 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Move xfs_attr_rolltrans to xfs_trans_roll
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com>
In-Reply-To: <1214196150-5427-3-git-send-email-xaiki@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

Niv Sardi wrote:
> Move it from the attr code to the transaction code and make the attr
> code call the new function.
> 
> We rolltrans is really usefull whenever we want to use rolling
> transaction, should be generic, it isn't dependent on any part of the
> attr code anyway.
> 
So you just have some renames on calls and change where func definition is located.
And you've added comments.


> +/*
> + * Roll from one trans in the sequence of PERMANENT transactions to
> + * the next: permanent transactions are only flushed out when commited
> + * with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon as
> + * possible to let chunks of it go to the log. So we commit the chunck
> + * we've been working on and get a new transaction to continue.
> + */

typos:
s/chunck/chunk/
s/commited/committed/

--Tim
