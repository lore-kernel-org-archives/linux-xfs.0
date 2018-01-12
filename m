Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754016AbeALBPz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 20:15:55 -0500
Subject: Re: [PATCH 02/27] xfs_scrub: common error handling
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520350018.2027.6588345400822739821.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2a192224-9951-9e10-f7ac-daf9bab2d9ea@sandeen.net>
Date: Thu, 11 Jan 2018 19:15:52 -0600
MIME-Version: 1.0
In-Reply-To: <151520350018.2027.6588345400822739821.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Standardize how we record and report errors.
> 


> +/*
> + * Reporting Status to the Console
> + *
> + * We aim for a roughly standard reporting format -- the severity of the
> + * status being reported, a textual description of the objecting being

object?  (I mean, I suppose it might be objecting to your horribly
corrupted filesystem?) ;)

> + * reported, and whatever the status happens to be.
> + *
> + * Errors are the most severe and reflect filesystem corruption.
> + * Warnings indicate that something is amiss and needs the attention of
> + * the administrator, but does not constitute a corruption.  Information
> + * is merely advisory.
> + */
> +


>  /* Program name; needed for libxcmd error reports. */
>  char				*progname = "xfs_scrub";
>  
> +/* Debug level; higher values mean more verbosity. */
> +unsigned int			debug;
> +
> +/* Should we dump core if errors happen? */
> +bool				dumpcore;

not independent of debug right, but ... *shrug* 

-Eric
