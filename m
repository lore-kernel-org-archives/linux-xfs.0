Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81500C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 05:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594D822522
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 05:13:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RN255lr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725208AbgA2FNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 00:13:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725816AbgA2FNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 00:13:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580274819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eoXCykABiQhAP1um5/47/S0PtyaiYlY7/O7HoAVb88=;
        b=RN255lr7IVrFMcRaFaQ+ne6bcR5frW4JJGrrwJTZX9KAyJfN44vwCutypms1iV5AXDVSZ9
        bSwsQ0QECDlPCD0axP1kqs02VGXnthnTBtCfYFoWBM3bFzFy0hX3jpvMF4ECTcodFLywjT
        E0h0hLrdHaJSQTl6wHtQPNGgzVxIt6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-0ZApfu1lMu6xi8LLggBIAg-1; Wed, 29 Jan 2020 00:13:35 -0500
X-MC-Unique: 0ZApfu1lMu6xi8LLggBIAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530DE107ACC5;
        Wed, 29 Jan 2020 05:13:34 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBEC860BE0;
        Wed, 29 Jan 2020 05:13:33 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:23:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: xfs mount option sanity test
Message-ID: <20200129052310.GJ14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20200115081132.22710-1-zlang@redhat.com>
 <20200118172330.GE2149943@magnolia>
 <20200119072342.GH14282@dhcp-12-102.nay.redhat.com>
 <20200127165728.GA3448165@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127165728.GA3448165@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 08:57:28AM -0800, Darrick J. Wong wrote:
> On Sun, Jan 19, 2020 at 03:23:42PM +0800, Zorro Lang wrote:
> > On Sat, Jan 18, 2020 at 09:23:30AM -0800, Darrick J. Wong wrote:
> > > On Wed, Jan 15, 2020 at 04:11:32PM +0800, Zorro Lang wrote:
> > > > XFS is changing to suit the new mount API, so add this case to make
> > > > sure the changing won't bring in regression issue on xfs mount option
> > > > parse phase, and won't change some default behaviors either.
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > Thanks the suggestions from Darrick, v3 did below changes:
> > > > 1) Add more debug info output in do_mkfs and do_test.
> > > > 2) A new function filter_loop.
> > > > 3) Update .out file content
> > > > 
> > > > I've simply run this case on RHEL-7, RHEL-8 and upstream 5.5-rc4 kernel,
> > > > all passed.
> > > 
> > > Something else I noticed -- if for whatever reason the mount fails due
> > > to log size checks, the kernel logs things like:
> > > 
> > > xfs: Bad value for 'logbufs'
> > > XFS (loop0): Mounting V5 Filesystem
> > > XFS (loop0): Log size 3273 blocks too small, minimum size is 3299 blocks
> > > XFS (loop0): AAIEEE! Log failed size checks. Abort!
> > > XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 706
> > 
> > Thanks Darrick, you always can find exceptions:) BTW, how to reproduce this
> > error?
> 
> It's the same problem as last time -- I run upstream xfsprogs (with the
> patch turning on rmap by default); and when this test runs apparently
> there are logbufs options that increase the kernel's view of the minimum
> log size to the point that we fail the mount time log size checks.
> 
> I observed that changing the LOOP_IMG creation code to make a 32G sparse
> file results in an fs with a larger log area:

Thanks, that's a good idea, sparse file helps to get larger log space!

> 
> 	$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
> 
> fixes all of these problems.  See diff below.
> 
> > Looks like I touched too many things in one case, cause I have a long way to
> > make it "no exception" ;)
> > 
> > > 
> > > Which is then picked up by the dmesg scanner in fstests.  Maybe we need
> > > (a) _check_dmesg between each _do_test iteration, and/or (b) filter that
> > > particular assertion so we don't fail the test?
> > 
> > I can add _check_dmesg between each _do_test iteration, but I have to exit
> > directly if _check_dmesg returns 1, or we need a way to save each failed
> > $seqres.dmesg (maybe just cat $seqres.dmesg ?)
> > 
> > About the dmesg filter, each _do_test can have its own filter if it need.
> > For example, "logbufs" test filter "Assertion failed: 0, file: fs/xfs/xfs_log.c".
> > But might that filter out useful kernel warning?
> > 
> > What do you think?
> 
> Eh, now that I've taken a second look at this, I don't think there's a
> good way to filter this particular ASSERT vs. any other that could pop
> up.

Sure, I'm afraid to filter more real bugs, if there's not a good way to
filter it.

> 
> --D
> 
> diff --git a/tests/xfs/997 b/tests/xfs/997
> index 6b7235dd..c5bb0e51 100755
> --- a/tests/xfs/997
> +++ b/tests/xfs/997
> @@ -50,11 +50,11 @@ LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
>  LOOP_MNT=$TEST_DIR/$seq.mnt
>  
>  echo "** create loop device"
> -$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> +$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
>  LOOP_DEV=`_create_loop_device $LOOP_IMG`
>  
>  echo "** create loop log device"
> -$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> +$XFS_IO_PROG -f -c "truncate 512m" $LOOP_SPARE_IMG
>  LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
>  
>  echo "** create loop mount point"
> 

