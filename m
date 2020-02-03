Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B2AC35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14CEA20838
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 23:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgBCXEV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 18:04:21 -0500
Received: from p3plmtsmtp04.prod.phx3.secureserver.net ([184.168.131.18]:59662
        "EHLO p3plmtsmtp04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgBCXEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 18:04:21 -0500
Received: from n64.mail01.mtsvc.net ([216.70.64.196])
        by :MT-SMTP: with ESMTP
        id ykkwibSXwwYhEykkwiS0if; Mon, 03 Feb 2020 16:03:50 -0700
X-SID:  ykkwibSXwwYhE
Received: from [162.248.116.186] (port=54109 helo=[192.168.101.29])
        by n64.mail01.mtsvc.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <alan@instinctualsoftware.com>)
        id 1iykkw-0007nS-8S; Mon, 03 Feb 2020 18:03:50 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: su & sw for HW-RAID60
From:   Alan Latteri <alan@instinctualsoftware.com>
In-Reply-To: <20200203225914.GB20628@dread.disaster.area>
Date:   Mon, 3 Feb 2020 15:03:47 -0800
Cc:     linux-xfs@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <03E9DDCF-9395-4E8A-A228-E8E5B004B111@instinctualsoftware.com>
References: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
 <20200203225914.GB20628@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Authenticated-User: 1434467 alan@instinctualsoftware.com
X-MT-ID: 9DCC79A4E204102198399334CA945B5BD229B688
X-CMAE-Envelope: MS4wfDZi9UuZeJIO2GODnVhm0f13c4mz4vgwRhaNOpE0X0Cqn4zReLaH0ZOKR+EXf+WQMEMgd/jWsZnkzyHqcOJJgzrXiakYYefbaBLKw6sA0zl3QFVuI2Fr
 RkTwQeU5bc98SrA2c7RQ6s87JB8XDlptlgIQO2VYHe0vxEbk9FQ3riJyjFfuWHjacRcOFJrCHlY6kBHN0pCrO3hJdyFKSAHAf9vlUgJZT5hgueDGzXIZMl3U
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the response.  Is this still the case even though the raid card is presenting the raid60 array as a large single 723TB drive?

Thanks,
Alan


> On Feb 3, 2020, at 2:59 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Mon, Feb 03, 2020 at 01:48:20PM -0800, Alan Latteri wrote:
>> Hello,
>> 
>> In an environment with an LSI 3108 based HW-RAID60, 256k stripe size on controller, 5 spans of (10data+2parity) disks.  What is the proper su & sw to use?  Do I do sw to the underlying 10 data disks per span? The top level 5 spans or all 50 data disks with the array?   Use case is as a file server for 20-60 MB per frame image sequences.
>> 
>> i.e
>> 
>> 1) sw=256k,sw=10
>> 2) sw=256k,sw=5
>> 3) sw=256k,sw=50
> 
> A HW RAID6 lun in this configuration behaves (and performs) like a
> single disk, so you're actually putting together a 5-disk raid-0
> stripe with a stripe unit of 2560kB.
> 
> i.e. for consistent performance and allocation alignment for large
> files, you want to do full RAID-6 stripe writes to each lun. Hence
> you want the filesytsem aligned to the first disk in each of the
> RAID-6 luns and to size allocations to full RAID6 lun width, not
> random individual drives in the RAID-6 luns.
> 
> IOWs:
> 
> sw=2560k,sw=5
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

