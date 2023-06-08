Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BCCC8300C
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 13:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbjFHNWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 09:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbjFHNWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 09:22:41 -0400
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76D51706
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1686230534; i=@fujitsu.com;
        bh=LwkjvrzorvOqYCIpMmAaycOOtf9eagWsQn8/Z8xQ5kg=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=jre9p09L4Z4nMYr6W22DYPR/Kdejs6SkqW53Uv/FdnuwXx9hma9krgCEGEgolQYhn
         2cuXKaYi/AEWJNOoQURS7Efm53f9XX4wZhS+TswrLL7oxH8QYJCRUXVzA8jJXH1C4w
         lXXWWQvDj8ZCTGybb8KjqdWKBmyjPiwZVn89e65bO24i19qbFlMMzEIwcpRCY19jEs
         Uu8nA0JC6oJ/ooaNAZqjyBJDjn+NhVsYx42GvHKETlCXRNFd5inNUfkqnsGNqc34ab
         E6znHdg8mzfIXb9hJqWAWoGhaoS9BqvO0xSUXwRhF3GQ9ThW7W3gvoQ6qa+Tv7XQyr
         DpkpfHboxwwcg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRWlGSWpSXmKPExsViZ8MxSZflWmO
  KwdRGKYt9l6YyWlx+wmex688Odgdmj02rOtk8Pm+SC2CKYs3MS8qvSGDN+PP8IlvBHPGKB8ek
  Ghj7hLoYuTiEBLYwSvT+OcDYxcgJ5Kxgkjh4uwoisY1RomX/BGaQBK+AncTtQ99ZQGwWARWJi
  9O3M0HEBSVOznwCFhcVSJGYsXExWL2wgKvExyl3WUFsEQFNiSPfroHVMwsYSnS0TWSCWFYmsX
  PqFXYQm01AR+LCgr9g9ZwCvhLP/nSzQNRbSCx+c5AdwpaXaN46G2y+hICSxMWvd1gh7CqJi+9
  nskHYahJXz21insAoNAvJebOQjJqFZNQCRuZVjObFqUVlqUW6hkZ6SUWZ6RkluYmZOXqJVbqJ
  eqmlunn5RSUZuoZ6ieXFeqnFxXrFlbnJOSl6eaklmxiBcZBSnNq+g/Horr96hxglOZiURHlLL
  zSmCPEl5adUZiQWZ8QXleakFh9ilOHgUJLg3QySEyxKTU+tSMvMAcYkTFqCg0dJhPfwOaA0b3
  FBYm5xZjpE6hSjLsfahgN7mYVY8vLzUqXEeXsuAhUJgBRllObBjYClh0uMslLCvIwMDAxCPAW
  pRbmZJajyrxjFORiVhHmXnwWawpOZVwK36RXQEUwgRyTVgxxRkoiQkmpgYlyy64h4+HVd9zin
  zpobZ2Z9aWQ7LBfpyL3o73dmbZ4LHfXbGzmdTVPmKD8REN/d6/m38tiOJctPVnwOVpk2kYfhu
  sicgMcMk+9nrVqqZXI7e8Nqdd4DF+Mq7PkmTeRxcgwKOXZGRn/GbunU5/HbTT/sDAno9Qzbt2
  LD4mI7uTo1trbrZu2S+iHG1ZtfczHd6830eCH+OW6ms1yLw5LIQ1FlzHLKGXOYC/av/CRWqG5
  6t8b02zQJ4/en7NaVb31y4ZrxHv78vVcXtzFkzXYK7RThOPq26HON/NRfUX1h8ZENqTquDl3a
  DbtC/+sEN3Pe+hZWZ7jPau4/xysbJstOEeDbz/6paLrXitWPeCYpsRRnJBpqMRcVJwIAFNM7/
  IoDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-4.tower-732.messagelabs.com!1686230532!8920!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.105.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6266 invoked from network); 8 Jun 2023 13:22:12 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-4.tower-732.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Jun 2023 13:22:12 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id CD4351000D5;
        Thu,  8 Jun 2023 14:22:11 +0100 (BST)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id C0A12100078;
        Thu,  8 Jun 2023 14:22:11 +0100 (BST)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 8 Jun 2023 14:22:09 +0100
Message-ID: <4af2621e-bd59-f1be-8e07-7800a68c59fa@fujitsu.com>
Date:   Thu, 8 Jun 2023 21:22:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHSET v25.0 0/7] xfs_scrub: fixes to the repair code
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <cem@kernel.org>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXHBPEKD10.g08.fujitsu.local (10.167.33.114) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

I'm running test on this patchset (patched kernel and xfsprogs, latest 
xfstests:v2023.05.28).  Now I found xfs/730 failed with message "online 
scrub didn't fail".  The detail is:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 f36 6.4.0-rc3-pmem+ #309 SMP 
PREEMPT_DYNAMIC Wed Jun  7 15:44:15 CST 2023
MKFS_OPTIONS  -- -f /dev/pmem1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem1 
/mnt/scratch

xfs/730       - output mismatch (see 
/root/xts/results//default/xfs/730.out.bad)
mv: failed to preserve ownership for 
'/root/xts/results//default/xfs/730.out.bad': Operation not permitted
     --- tests/xfs/730.out	2023-03-16 09:42:15.256141472 +0800
     +++ /root/xts/results//default/xfs/730.out.bad	2023-06-08 
20:43:27.436083265 +0800
     @@ -1,4 +1,14 @@
      QA output created by 730
      Format and populate
      Fuzz fscounters
     +icount = zeroes: online scrub didn't fail.
     +icount = ones: online scrub didn't fail.
     +icount = firstbit: online scrub didn't fail.
     +icount = middlebit: online scrub didn't fail.
     ...
     (Run 'diff -u /root/xts/tests/xfs/730.out 
/root/xts/results//default/xfs/730.out.bad'  to see the entire diff)


This test case is to fuzz metadata and make sure xfs_scrub can repair 
the fs. After a little investigation, I think the fuzz actually done to 
the metadata area but the xfs_scrub seems didn't notice that.  I haven't 
found the root cause of the problem yet.  Do you have the same message 
which causes fail on this case?


--
Thanks,
Ruan.

在 2023/5/26 8:38, Darrick J. Wong 写道:
> Hi all,
> 
> Now that we've landed the new kernel code, it's time to reorganize the
> xfs_scrub code that handles repairs.  Clean up various naming warts and
> misleading error messages.  Move the repair code to scrub/repair.c as
> the first step.  Then, fix various issues in the repair code before we
> start reorganizing things.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
> ---
>   scrub/phase1.c        |    2
>   scrub/phase2.c        |    3 -
>   scrub/phase3.c        |    2
>   scrub/phase4.c        |   22 ++++-
>   scrub/phase5.c        |    2
>   scrub/phase6.c        |   13 +++
>   scrub/phase7.c        |    2
>   scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
>   scrub/repair.h        |   16 +++-
>   scrub/scrub.c         |  204 +------------------------------------------------
>   scrub/scrub.h         |   16 ----
>   scrub/scrub_private.h |   55 +++++++++++++
>   scrub/xfs_scrub.c     |    2
>   13 files changed, 283 insertions(+), 233 deletions(-)
>   create mode 100644 scrub/scrub_private.h
> 
