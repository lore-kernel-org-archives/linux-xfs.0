Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbeCOMTm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:19:42 -0400
Subject: Re: [PATCH 1/2] xfs: always check for and process unlinked inodes on
 mount
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <d35d1067-a6f6-09be-9c4c-3e08a3bec3be@sandeen.net>
 <20180315121717.GA45325@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <60f1a77c-61f7-08fc-dffd-4734b1efd322@sandeen.net>
Date: Thu, 15 Mar 2018 08:19:40 -0400
MIME-Version: 1.0
In-Reply-To: <20180315121717.GA45325@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 3/15/18 8:17 AM, Brian Foster wrote:
> Have we considered anything like conditionally dirtying the log on
> freeze only when there are open+unlinked files? It seems like that may
> be uncommon enough to address the problem for snapshot users
> (particularly the read-only use case mentioned in the cover letter), but
> that's just a guess.
> 
> Brian


I did consider that, and was weighing the advantages with the disadvantages,
namely unpredictable behavior for snapshots...  I'm not sure how uncommon
the situation really is.

Regarding the mount delay, Darrick suggested that maybe we need to get
all these scans into one place if possible, for efficiency.

-Eric
