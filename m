Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752381AbdHJQqk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 12:46:40 -0400
Subject: Re: [PATCH v2] fiemap: Allow to specify range to fiemap
References: <20170810120439.GO21024@dastard>
 <1502368241-8928-1-git-send-email-nborisov@suse.com>
 <20170810161322.GV24087@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c254f712-e2bd-502b-515f-5ba20097bffd@suse.com>
Date: Thu, 10 Aug 2017 19:46:35 +0300
MIME-Version: 1.0
In-Reply-To: <20170810161322.GV24087@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com



On 10.08.2017 19:13, Darrick J. Wong wrote:
> We don't decrement len each time through the ioctl loop?  Doesn't that
> cause us to request and retrieve rows for ranges we don't want?

Hm, you are right, I believe on every iteration we should do:

len -= last_logical - start_offset
