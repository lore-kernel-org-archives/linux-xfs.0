Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdBJEVB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 23:21:01 -0500
Date: Fri, 10 Feb 2017 12:20:40 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG 4.10-rc7] sb_fdblocks inconsistency in xfs/297 test
Message-ID: <20170210042040.GA21408@eguan.usersys.redhat.com>
References: <20170210035348.GA7075@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210035348.GA7075@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mhocko@suse.com

On Fri, Feb 10, 2017 at 11:53:48AM +0800, Eryu Guan wrote:
> Hi,
> 
> I was testing 4.10-rc7 kernel and noticed that xfs_repair reported XFS
> corruption after fstests xfs/297 test. This didn't happen with 4.10-rc6

Seems generic/269 reproduces it easily too. I also saw xfs/167 fail on
ppc64 host because of this issue, but rarely.

Thanks,
Eryu
