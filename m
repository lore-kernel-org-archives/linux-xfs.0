Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD931C3A5A5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A03CD22DBF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfICDxD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 23:53:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfICDxD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Sep 2019 23:53:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4418D10A812B;
        Tue,  3 Sep 2019 03:53:02 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE50D60BE0;
        Tue,  3 Sep 2019 03:53:01 +0000 (UTC)
Date:   Tue, 3 Sep 2019 12:00:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: new helper to skip xfs_check
Message-ID: <20190903040000.GT7239@dhcp-12-102.nay.redhat.com>
References: <20190902135358.22134-1-zlang@redhat.com>
 <20190902170701.GT5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902170701.GT5354@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 03 Sep 2019 03:53:02 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 02, 2019 at 10:07:01AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 02, 2019 at 09:53:58PM +0800, Zorro Lang wrote:
> > The _xfs_check sometimes need to take too much memory, some quota
> > related cases (e.g: xfs/442, generic/232 etc) always trigger OOM
> > killer.
> > 
> >   [93334.020194] xfs_db invoked oom-killer: gfp_mask=0x6200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null), order=0, oom_score_adj=-1000
> >   [93334.020206] xfs_db cpuset=/ mems_allowed=0
> >   [93334.020213] CPU: 2 PID: 977 Comm: xfs_db Kdump: loaded Not tainted 4.18.0-139.el8.ppc64le+debug #1
> >   [93334.020217] Call Trace:
> >   [93334.020223] [c0000001cb163640] [c000000001035754] dump_stack+0xe8/0x164 (unreliable)
> >   [93334.020229] [c0000001cb163690] [c0000000004a77dc] dump_header+0x7c/0x670
> >   [93334.020234] [c0000001cb1637b0] [c0000000004a872c] oom_kill_process+0x26c/0x3d0
> >   [93334.020239] [c0000001cb163800] [c0000000004aa438] out_of_memory+0x278/0x930
> >   [93334.020244] [c0000001cb1638a0] [c0000000004bd6c8] __alloc_pages_nodemask+0x1ab8/0x1b70
> >   [93334.020248] [c0000001cb163ae0] [c00000000058b8dc] alloc_pages_vma+0xec/0x660
> >   [93334.020253] [c0000001cb163b50] [c00000000052b544] do_anonymous_page+0x124/0xac0
> >   [93334.020258] [c0000001cb163bc0] [c000000000534918] __handle_mm_fault+0xda8/0x1b60
> >   [93334.020263] [c0000001cb163cb0] [c000000000535948] handle_mm_fault+0x278/0x5a0
> >   [93334.020268] [c0000001cb163d00] [c00000000008b30c] __do_page_fault+0x27c/0xe00
> >   [93334.020273] [c0000001cb163df0] [c00000000008bec8] do_page_fault+0x38/0xf0
> >   [93334.020278] [c0000001cb163e30] [c00000000000a904] handle_page_fault+0x18/0x38
> >   [93334.020281] Mem-Info:
> >   [93334.020286] active_anon:93769 inactive_anon:13540 isolated_anon:0
> >   [93334.020286]  active_file:23 inactive_file:8 isolated_file:0
> >   [93334.020286]  unevictable:0 dirty:0 writeback:0 unstable:0
> >   [93334.020286]  slab_reclaimable:1543 slab_unreclaimable:8926
> >   [93334.020286]  mapped:69 shmem:15 pagetables:76 bounce:0
> >   [93334.020286]  free:2756 free_pcp:0 free_cma:0
> > 
> > The xfs_check related code is old, and nearly won't be maintained
> > too much, test xfs_repair and xfs_scrub is much more important than
> > xfs_check. But the xfstests always do a POST-xfs_check at the end of
> > each cases. So I'd like to add a new helper named
> > _require_scratch_no_xfs_check to skip xfs_check from some sub-cases.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > Maybe this patch not the best way to deal with this issue. Please feel free to
> > tell me if you have better idea.
> 
> I would just get rid of it (and have tried several times) but have not
> had the time to check that xfs_repair can detect every corruption that
> xfs_check can.
> 
> (To get started, I think it involves forking the dangerous_repair group
> tests to run _xfs_check and xfs_repair -n one after the other to compare
> outputs.)

JFYI, I remembered I hit once xfs_check failure[1] which xfs_repair -n didn't
find. And then, this bug fixed by another bug(CLOSE DUPLICATE):
https://bugzilla.kernel.org/show_bug.cgi?id=200137

Thanks,
Zorro


_check_xfs_filesystem: filesystem on /dev/mapper/xxxx-xfstest is inconsistent (c)
*** xfs_check output ***
bad nblocks 2 for free inode 1028
block 0/549 type unknown not expected
block 0/550 type unknown not expected

# xfs_repair -n /dev/mapper/xxxx-xfstest
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 05:54:54: scanning filesystem freespace - 16 of 16 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 05:54:54: scanning agi unlinked lists - 16 of 16 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 05:54:54: process known inodes and inode discovery - 64 of 64 inodes done
        - process newly discovered inodes...
        - 05:54:54: process newly discovered inodes - 16 of 16 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 05:54:54: setting up duplicate extent list - 16 of 16 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 6
        - agno = 10
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 8
        - agno = 7
        - agno = 1
        - agno = 9
        - agno = 15
        - agno = 11
        - agno = 12
        - agno = 14
        - agno = 13
        - agno = 2
        - 05:54:54: check for inodes claiming duplicate blocks - 64 of 64 inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ... 
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 05:54:54: verify and correct link counts - 16 of 16 allocation groups done
No modify flag set, skipping filesystem flush and exiting.

# xfs_db -F -i -p xfs_check -c "check" /dev/mapper/xxxx-xfstest                                                                             
bad nblocks 2 for free inode 1028              
block 0/549 type unknown not expected          
block 0/550 type unknown not expected


> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> >  common/rc         |  1 +
> >  common/xfs        | 26 ++++++++++++++++++++++++++
> >  tests/generic/232 |  2 ++
> >  tests/generic/233 |  2 ++
> >  tests/generic/234 |  2 ++
> >  tests/xfs/442     |  2 ++
> >  6 files changed, 35 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index e0b087c1..86eeda16 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1570,6 +1570,7 @@ _require_scratch()
> >  {
> >  	_require_scratch_nocheck
> >  	touch ${RESULT_DIR}/require_scratch
> > +	touch ${RESULT_DIR}/require_scratch.xfs_check
> >  }
> >  
> >  # require a scratch dev of a minimum size (in kb)
> > diff --git a/common/xfs b/common/xfs
> > index 1bce3c18..80e6d1e8 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -168,11 +168,37 @@ _scratch_mkfs_xfs()
> >  	return $mkfs_status
> >  }
> >  
> > +# Usage: _require_scratch_no_xfs_check [limit_memsize]
> > +#
> > +# Due to xfs_check costs too much memory, sometimes it cause OOM when test on
> > +# low memory machine. This function is used to skip xfs_check conditionally
> > +# or unconditionally.
> > +#
> > +# Note: must be called after _require_scratch.
> > +_require_scratch_no_xfs_check()
> > +{
> > +	local bound=$1
> > +	local freemem
> > +
> > +	freemem=`_free_memory_bytes`
> > +	if [ -n "$bound" ];then
> > +		if [ $freemem -lt $bound ];then
> > +			rm -f ${RESULT_DIR}/require_scratch.xfs_check
> > +		fi
> > +	else
> > +		rm -f ${RESULT_DIR}/require_scratch.xfs_check
> > +	fi
> > +}
> > +
> >  # xfs_check script is planned to be deprecated. But, we want to
> >  # be able to invoke "xfs_check" behavior in xfstests in order to
> >  # maintain the current verification levels.
> >  _xfs_check()
> >  {
> > +	if [ ! -f "${RESULT_DIR}/require_scratch.xfs_check" ];then
> > +		return 0
> > +	fi
> > +
> >  	OPTS=" "
> >  	DBOPTS=" "
> >  	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
> > diff --git a/tests/generic/232 b/tests/generic/232
> > index d5c20249..20841313 100755
> > --- a/tests/generic/232
> > +++ b/tests/generic/232
> > @@ -52,6 +52,8 @@ _fsstress()
> >  _supported_fs generic
> >  _supported_os Linux
> >  _require_scratch
> > +# Do post xfs_check, if free memory size > 16G
> > +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
> >  _require_quota
> >  
> >  _scratch_mkfs > $seqres.full 2>&1
> > diff --git a/tests/generic/233 b/tests/generic/233
> > index c49bf252..7933d4b8 100755
> > --- a/tests/generic/233
> > +++ b/tests/generic/233
> > @@ -56,6 +56,8 @@ _fsstress()
> >  _supported_fs generic
> >  _supported_os Linux
> >  _require_scratch
> > +# Do post xfs_check, if free memory size > 16G
> > +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
> >  _require_quota
> >  _require_user
> >  
> > diff --git a/tests/generic/234 b/tests/generic/234
> > index dc296df8..e843dc10 100755
> > --- a/tests/generic/234
> > +++ b/tests/generic/234
> > @@ -72,6 +72,8 @@ test_setting()
> >  _supported_fs generic
> >  _supported_os Linux
> >  _require_scratch
> > +# Do post xfs_check, if free memory size > 16G
> > +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
> >  _require_quota
> >  
> >  # real QA test starts here
> > diff --git a/tests/xfs/442 b/tests/xfs/442
> > index 7a5f2e8e..9e891b51 100755
> > --- a/tests/xfs/442
> > +++ b/tests/xfs/442
> > @@ -36,6 +36,8 @@ _supported_fs xfs
> >  _supported_os Linux
> >  
> >  _require_scratch_reflink
> > +# Do post xfs_check, if free memory size > 16G
> > +_require_scratch_no_xfs_check $((16 * 1024 * 1024 * 1024))
> >  _require_quota
> >  _require_command "$KILLALL_PROG" "killall"
> >  
> > -- 
> > 2.17.2
> > 
