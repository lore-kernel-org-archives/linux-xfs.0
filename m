Return-Path: <SRS0=4IRk=BR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42940C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 16:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251EA22CAE
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 16:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGQ5h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:57:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:57368 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGQ5g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Aug 2020 12:57:36 -0400
IronPort-SDR: BZpN7Cm140+N6gZHS85IvacTqLKPxu+GQoO4Xm7bsRCg1km+ja6BE/znsiuTfBH/BlL4A4XqUV
 knQfXCUFFc3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="150588458"
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="150588458"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 09:57:36 -0700
IronPort-SDR: n4CkeIe28H38u7Uaa8ERfKgh1Cox9+iyqWcsxjR42bov1J3PLAVw09LjRUswIhXm3mygyJKzga
 G6iv2KFg3znw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="289678839"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by orsmga003.jf.intel.com with ESMTP; 07 Aug 2020 09:57:35 -0700
Date:   Fri, 7 Aug 2020 09:57:35 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        yangx.jy@cn.fujitsu.com, ruansy.fnst@cn.fujitsu.com,
        gujx@cn.fujitsu.com, Yasunori Goto <y-goto@fujitsu.com>
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Message-ID: <20200807165731.GT1573827@iweiny-DESK2.sc.intel.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
 <20200729161040.GA1250504@iweiny-DESK2.sc.intel.com>
 <5717e1e5-79fb-af3c-0859-eea3cd8d9626@cn.fujitsu.com>
 <ed4b2df4-086f-a384-3695-4ea721a70326@cn.fujitsu.com>
 <20200805154443.GA6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805154443.GA6096@magnolia>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 05, 2020 at 08:44:43AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 05, 2020 at 04:10:05PM +0800, Li, Hao wrote:
> > Hello,
> > 
> > Ping.
> > 
> > Thanks,
> > Hao Li
> > 
> > 
> > On 2020/7/31 17:12, Li, Hao wrote:
> > > On 2020/7/30 0:10, Ira Weiny wrote:
> > >
> > >> On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
> > >>> Hi,
> > >>>
> > >>> On 2020/07/28 11:20, Dave Chinner wrote:
> > >>>> On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
> > >>>>> Hi,
> > >>>>>
> > >>>>> I have noticed that we have to drop caches to make the changing of S_DAX
> > >>>>> flag take effect after using chattr +x to turn on DAX for a existing
> > >>>>> regular file. The related function is xfs_diflags_to_iflags, whose
> > >>>>> second parameter determines whether we should set S_DAX immediately.
> > >>>> Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
> > >>>>
> > >>>>   6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
> > >>>>      the change in behaviour for existing regular files may not occur
> > >>>>      immediately.  If the change must take effect immediately, the administrator
> > >>>>      needs to:
> > >>>>
> > >>>>      a) stop the application so there are no active references to the data set
> > >>>>         the policy change will affect
> > >>>>
> > >>>>      b) evict the data set from kernel caches so it will be re-instantiated when
> > >>>>         the application is restarted. This can be achieved by:
> > >>>>
> > >>>>         i. drop-caches
> > >>>>         ii. a filesystem unmount and mount cycle
> > >>>>         iii. a system reboot
> > >>>>
> > >>>>> I can't figure out why we do this. Is this because the page caches in
> > >>>>> address_space->i_pages are hard to deal with?
> > >>>> Because of unfixable races in the page fault path that prevent
> > >>>> changing the caching behaviour of the inode while concurrent access
> > >>>> is possible. The only way to guarantee races can't happen is to
> > >>>> cycle the inode out of cache.
> > >>> I understand why the drop_cache operation is necessary. Thanks.
> > >>>
> > >>> BTW, even normal user becomes to able to change DAX flag for an inode,
> > >>> drop_cache operation still requires root permission, right?
> > >>>
> > >>> So, if kernel have a feature for normal user can operate drop cache for "a
> > >>> inode" with
> > >>> its permission, I think it improve the above limitation, and
> > >>> we would like to try to implement it recently.
> > >>>
> > >>> Do you have any opinion making such feature?
> > >>> (Agree/opposition, or any other comment?)
> > >> I would not be opposed but there were many hurdles to that implementation.
> > >>
> > >> What is the use case you are thinking of here?
> > >>
> > >> The compromise of dropping caches was reached because we envisioned that many
> > >> users would simply want to chose the file mode when a file was created and
> > >> maintain that mode through the lifetime of the file.  To that end one can
> > >> simply create directories which have the desired dax mode and any files created
> > >> in that directory will inherit the dax mode immediately.  
> > > Inheriting mechanism for DAX mode is reasonable but chattr&drop_caches
> > > makes things complicated.
> > >> So there is no need
> > >> to switch the file mode directly as a normal user.
> > > The question is, the normal users can indeed use chattr to change the DAX
> > > mode for a regular file as long as they want. However, when they do this,
> > > they have no way to make the change take effect. I think this behavior is
> > > weird. We can say chattr executes successfully because XFS_DIFLAG2_DAX has
> > > been set onto xfs_inode->i_d.di_flags2, but we can also say chattr doesn't
> > > finish things completely because S_DAX is not set onto inode->i_flags.
> > > The user may be confused about why chattr +/-x doesn't work at all. Maybe
> > > we should find a way for the normal user to make chattr take effects
> > > without calling the administrator, or we can make the chattr +/x command
> > > request root permission now that if the user has root permission, he can
> > > make DAX changing take effect through echo 2 > /proc/sys/vm/drop_caches.
> 
> The kernel can sometimes make S_DAX changes take effect on its own,
> provided that there are no other users of the file and the filesystem
> agrees to reclaim an inode on file close and the program closes the file
> after changing the bit.  None of these behaviors are guaranteed to
> exist, so this is not mentioned in the documentation.
> 
> (And before anyone asks, yes, we did try to build a way to change the
> file ops on the fly, but adding more concurrency control to all io paths
> to handle an infrequent state change is not acceptable.)

Thanks Darrick.  sorry for the delay...

Darrick is absolutely correct.  But I would like to add that the user can check
the current file status (S_DAX flag) by using statx.  So while they don't have
control they can at least see what is happening.

This was the compromise we had to make considering the complexities of changing
a file on the fly.

This was discussed at length on the mailing list:

https://lore.kernel.org/lkml/20200422212102.3757660-5-ira.weiny@intel.com/

Also, we do try our best to evict the inode as soon as possible 'automatically'

https://lore.kernel.org/lkml/20200409124127.GB18171@lst.de/

But there is just no guarantee that someone out there (a backup utility for
example) is not using the inode.  So the user just can't control this
absolutely.

Ira

> 
> --D
> 
> > >
> > >
> > > Regards,
> > >
> > > Hao Li
> > >
> > >> Would that work for your use case?
> > >>
> > >> Ira
> > 
> > 
