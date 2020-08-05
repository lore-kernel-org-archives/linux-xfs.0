Return-Path: <SRS0=76Cg=BP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B095C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 17:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A58922D06
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 17:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UFpxIw9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgHERZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Aug 2020 13:25:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgHERYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Aug 2020 13:24:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075Fg6JV159565;
        Wed, 5 Aug 2020 15:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hAPyO6ErkspcDvWzqwiERHdrOCdauIvL+acu6djGQJg=;
 b=UFpxIw9cPw79jmgvj7QWrOervGF/ou3Xm/NXBMpxJuTKvcIOLltAyhcKre78zy2DfNdT
 hvx4cr5+lJ8BwHbv8msacsn7SodhBVhzv3P6ongz6ChJ3te/0VRr2ktEMXL5evrvMEiC
 PPqt2wHxe6NjK5FmJNWNG1J+WfA5RFs4pP8ikK0kC2e3Syp+kAgg9lOAbxPs4y2AVEuJ
 91cwifntuEAlpXei0qhVubR5hI6YH3Pqfhajqca11UhcRw02ZxgkqOcQkeVE51CYoSRw
 1H3d8PGngSaWyqobz19i3mY6c8hB1QFHBAytMu/u+mqIPwkF8hm82rRUE6mI4kPvFDEn IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32n11natg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 15:44:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075FgwgL104177;
        Wed, 5 Aug 2020 15:44:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32qy8kh5p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 15:44:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 075Fijdh015819;
        Wed, 5 Aug 2020 15:44:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Aug 2020 08:44:45 -0700
Date:   Wed, 5 Aug 2020 08:44:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        yangx.jy@cn.fujitsu.com, ruansy.fnst@cn.fujitsu.com,
        gujx@cn.fujitsu.com, Yasunori Goto <y-goto@fujitsu.com>
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Message-ID: <20200805154443.GA6096@magnolia>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
 <20200729161040.GA1250504@iweiny-DESK2.sc.intel.com>
 <5717e1e5-79fb-af3c-0859-eea3cd8d9626@cn.fujitsu.com>
 <ed4b2df4-086f-a384-3695-4ea721a70326@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed4b2df4-086f-a384-3695-4ea721a70326@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=1 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 05, 2020 at 04:10:05PM +0800, Li, Hao wrote:
> Hello,
> 
> Ping.
> 
> Thanks,
> Hao Li
> 
> 
> On 2020/7/31 17:12, Li, Hao wrote:
> > On 2020/7/30 0:10, Ira Weiny wrote:
> >
> >> On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
> >>> Hi,
> >>>
> >>> On 2020/07/28 11:20, Dave Chinner wrote:
> >>>> On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I have noticed that we have to drop caches to make the changing of S_DAX
> >>>>> flag take effect after using chattr +x to turn on DAX for a existing
> >>>>> regular file. The related function is xfs_diflags_to_iflags, whose
> >>>>> second parameter determines whether we should set S_DAX immediately.
> >>>> Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
> >>>>
> >>>>   6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
> >>>>      the change in behaviour for existing regular files may not occur
> >>>>      immediately.  If the change must take effect immediately, the administrator
> >>>>      needs to:
> >>>>
> >>>>      a) stop the application so there are no active references to the data set
> >>>>         the policy change will affect
> >>>>
> >>>>      b) evict the data set from kernel caches so it will be re-instantiated when
> >>>>         the application is restarted. This can be achieved by:
> >>>>
> >>>>         i. drop-caches
> >>>>         ii. a filesystem unmount and mount cycle
> >>>>         iii. a system reboot
> >>>>
> >>>>> I can't figure out why we do this. Is this because the page caches in
> >>>>> address_space->i_pages are hard to deal with?
> >>>> Because of unfixable races in the page fault path that prevent
> >>>> changing the caching behaviour of the inode while concurrent access
> >>>> is possible. The only way to guarantee races can't happen is to
> >>>> cycle the inode out of cache.
> >>> I understand why the drop_cache operation is necessary. Thanks.
> >>>
> >>> BTW, even normal user becomes to able to change DAX flag for an inode,
> >>> drop_cache operation still requires root permission, right?
> >>>
> >>> So, if kernel have a feature for normal user can operate drop cache for "a
> >>> inode" with
> >>> its permission, I think it improve the above limitation, and
> >>> we would like to try to implement it recently.
> >>>
> >>> Do you have any opinion making such feature?
> >>> (Agree/opposition, or any other comment?)
> >> I would not be opposed but there were many hurdles to that implementation.
> >>
> >> What is the use case you are thinking of here?
> >>
> >> The compromise of dropping caches was reached because we envisioned that many
> >> users would simply want to chose the file mode when a file was created and
> >> maintain that mode through the lifetime of the file.  To that end one can
> >> simply create directories which have the desired dax mode and any files created
> >> in that directory will inherit the dax mode immediately.  
> > Inheriting mechanism for DAX mode is reasonable but chattr&drop_caches
> > makes things complicated.
> >> So there is no need
> >> to switch the file mode directly as a normal user.
> > The question is, the normal users can indeed use chattr to change the DAX
> > mode for a regular file as long as they want. However, when they do this,
> > they have no way to make the change take effect. I think this behavior is
> > weird. We can say chattr executes successfully because XFS_DIFLAG2_DAX has
> > been set onto xfs_inode->i_d.di_flags2, but we can also say chattr doesn't
> > finish things completely because S_DAX is not set onto inode->i_flags.
> > The user may be confused about why chattr +/-x doesn't work at all. Maybe
> > we should find a way for the normal user to make chattr take effects
> > without calling the administrator, or we can make the chattr +/x command
> > request root permission now that if the user has root permission, he can
> > make DAX changing take effect through echo 2 > /proc/sys/vm/drop_caches.

The kernel can sometimes make S_DAX changes take effect on its own,
provided that there are no other users of the file and the filesystem
agrees to reclaim an inode on file close and the program closes the file
after changing the bit.  None of these behaviors are guaranteed to
exist, so this is not mentioned in the documentation.

(And before anyone asks, yes, we did try to build a way to change the
file ops on the fly, but adding more concurrency control to all io paths
to handle an infrequent state change is not acceptable.)

--D

> >
> >
> > Regards,
> >
> > Hao Li
> >
> >> Would that work for your use case?
> >>
> >> Ira
> 
> 
