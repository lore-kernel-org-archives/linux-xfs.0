Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 15:26:00 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KNPrea030370
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 15:25:54 -0800
Date: Wed, 20 Feb 2008 18:26:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] Don't change ctime in truncate is size does not change
Message-ID: <20080220232615.GA25493@infradead.org>
References: <20080218233251.GV155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218233251.GV155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

> +		if (vap->va_size != ip->i_size || mask & XFS_AT_CTIME)

Normal Linux style is to always have braces around the 'foo & bar'
statements to avoid operator precedance problems when re-ordering the
statements.  Otherwise this one looks good.
