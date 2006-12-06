Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Dec 2006 00:44:48 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB68idaG006283
	for <xfs@oss.sgi.com>; Wed, 6 Dec 2006 00:44:40 -0800
Message-ID: <457682C3.6000802@sgi.com>
Date: Wed, 06 Dec 2006 08:43:47 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <457080EA.1010807@sgi.com> <20061203234928.GA37654165@melbourne.sgi.com> <45755C26.2080505@gmx.net> <20061205215503.GW44411608@melbourne.sgi.com>
In-Reply-To: <20061205215503.GW44411608@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Klaus Strebel <klaus.strebel@gmx.net>, xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Dec 05, 2006 at 12:46:46PM +0100, Klaus Strebel wrote:
> 
>>Hi guys,
>>
>>just updated my CVS copy from oss.sgi.com ( the linux-2.6-xfs ) and 
>>tried to compile ... but your patch failes to compile if HAVE_PERCPU_SB 
>>is #ifndef'd :-(, the m_icsb_mutex is not in the struct see xfs_mount.h. 
>>Make oldconfig didn't show HAVE_PERCPU_SB as option for .config, looks 
>>like nobody tested on a single processor config ??
> 
> 
> Sorry - my bad. The code did not change for UP, so I didn't think to
> test it.  The patch below abstracts the icsb_mutex so that it
> doesn't get directly referenced by code outside the per-cpu counter
> code. Builds with and without HAVE_PERCPU_SB defined.
> 
> I'll run a test cycle on it and get it fixed up.
> 
> Cheers,
> 
> Dave.

@@ -1803,6 +1803,7 @@ xfs_icsb_destroy_counters(
  		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
  		free_percpu(mp->m_sb_cnts);
  	}
+	mutex_destroy(&mp->m_icsb_mutex);
  }

Do you need to abstract the call to mutex_destroy too?

The rest of the change looks good.

Lachlan
