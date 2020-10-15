Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BB4C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B56A72224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KTO+HQEM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgJOFjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:39:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgJOFjV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:39:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5YbKh124701;
        Thu, 15 Oct 2020 05:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=At+sg7uGy8KUk2KJpoCtQ/mHISuhHRS4F9VdoB1vchI=;
 b=KTO+HQEMBgSUZHTV6vhtpWTGcW5ZW7qUcgVRFCDMkJopvFTOoD3Mqom20+Shto3oXD/i
 MQ4RWfeJElwT8joJuQuhc2IoqXPyvqE9wuFNDvNXhxSY5hdqkWZ4bk5G8vGmp8mHBhrZ
 l2IOGODVbaqXkUauckqBtB5fF/XOH21k1KGVxk9gv2z+yWgY5gNhUbeJN9aCdPS5G6sN
 CcwBOEXhXBPrkqRxZbs+dj+wLynupY+yn+6v93M/9gAsGKQHPWhtPrYmIUn6nGd+exUJ
 lvMACoqoKiOvMIenDfQstqJRM1AnBf+FqHUXv56BPUfRo124lojvV1WmEcQc2TDiYl4b /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3434wktuw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:39:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5ZjhZ053564;
        Thu, 15 Oct 2020 05:39:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 343phqk9x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:39:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09F5dH98006687;
        Thu, 15 Oct 2020 05:39:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:39:17 -0700
Date:   Wed, 14 Oct 2020 22:39:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] mkfs: Configuration file defined options
Message-ID: <20201015053916.GQ9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015051300.GM9832@magnolia>
 <20201015053234.GE7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015053234.GE7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 04:32:34PM +1100, Dave Chinner wrote:
> On Wed, Oct 14, 2020 at 10:13:00PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 15, 2020 at 02:29:20PM +1100, Dave Chinner wrote:
> > > Version 2:
> > > 
> > > - "-c file=xxx" > "-c options=xxx"
> > > - split out constification into new patch
> > > - removed debug output
> > > - fixed some comments
> > > - added man page stuff
> > > 
> > > Hi Folks,
> > > 
> > > Because needing config files for mkfs came up yet again in
> > > discussion, here is a simple implementation of INI format config
> > > files. These config files behave identically to options specified on
> > > the command line - the do not change defaults, they do not override
> > > CLI options, they are not overridden by cli options.
> > > 
> > > Example:
> > > 
> > > $ echo -e "[metadata]\ncrc = 0" > foo
> > > $ mkfs/mkfs.xfs -N -c options=foo -d file=1,size=100m blah
> > > Parameters parsed from config file foo successfully
> > > meta-data=blah                   isize=256    agcount=4, agsize=6400 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=0        finobt=0, sparse=0, rmapbt=0
> > >          =                       reflink=0
> > > data     =                       bsize=4096   blocks=25600, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=853, version=2
> > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > $
> > > 
> > > And there's a V4 filesystem as specified by the option defined
> > > in the config file. If we do:
> > > 
> > > $ mkfs/mkfs.xfs -N -c options=foo -m crc=1 -d file=1,size=100m blah
> > > -m crc option respecified
> > > Usage: mkfs.xfs
> > > .....
> > > $
> > > 
> > > You can see it errors out because the CRC option was specified in
> > > both the config file and on the CLI.
> > > 
> > > There's lots of stuff we can do to make the conflict and respec
> > > error messages better, but that doesn't change the basic
> > > functionality of config file based mkfs options. To allow for future
> > > changes to the way we want to apply config files, I created a
> > > full option subtype for config files. That means we can add another
> > > option to say "apply config file as default values rather than as
> > > options" if we decide that is functionality that we want to support.
> > > 
> > > However, policy decisions like that are completely separate to the
> > > mechanism, so these patches don't try to address desires to ship
> > > "tuned" configs, system wide option files, shipping distro specific
> > > defaults in config files, etc. This is purely a mechanism to allow
> > > users to specify options via files instead of on the CLI.  No more,
> > > no less.
> > > 
> > > This has only been given a basic smoke testing right now (see above!
> > > :).  I need to get Darrick's tests from the previous round of config
> > 
> > This was in the v1 series; have you gotten Darrick's fstests to do more
> > substantial testing? ;)
> 
> I got as far as asking you "where did you get your INI format
> specification from?" because the tests assume stuff that I don't
> think is valid about whitespace and comment structure in the format.
> And then I disappeared down a rathole of "there is no one true
> specification for INI files" and then something else came up....
> 
> I have not got back to culling the whitespace craziness from those
> tests yet. The only format I'm considering supporting is what the
> library itself actually supports, and that means random whitespace
> in names, values and section headers will be a bad configuration
> file format error.

Yeah.  The ini format craziness was a direct result of me trying to
(re)interpret the format based on the line formats that the previous
round of patches coded into mkfs.  Perhaps the only parts easily
salvageable are the ones that actually test the config file options
themselves...

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
