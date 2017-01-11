Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40239 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936299AbdAKITm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:19:42 -0500
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
References: <20170110101745.4841-1-jack@suse.cz>
 <7ecf901b-ecbd-3914-25c3-1f6f6faf3264@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <55cb9bb8-c5aa-09c6-b08a-1c4da880dfc4@suse.cz>
Date: Wed, 11 Jan 2017 09:19:40 +0100
MIME-Version: 1.0
In-Reply-To: <7ecf901b-ecbd-3914-25c3-1f6f6faf3264@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Brian Foster <bfoster@redhat.com>

On 01/11/2017 09:07 AM, Vlastimil Babka wrote:
> Now MemAvailable is based on NR_FREE_PAGES and NR_[IN]ACTIVE_FILE (I
> actually wonder why the value is so high here, it should consider only
> half of the file LRU's as available, according to the comment there...
> oh, I see, there's a math error there, I'll report that separately...).

Ah, looks like the comment is just somewhat ambiguous. "half of the file
LRU's" applies only if their size is below the low watermarks. The code
seems to do the right thing.
