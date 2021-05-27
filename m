Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FFFC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 10:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D05860FEB
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 10:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhE0KUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 06:20:05 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:48872 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhE0KUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 06:20:04 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2021 06:20:04 EDT
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 14RA6PL9004568
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 03:06:27 -0700
Message-ID: <60AF6EF9.8030803@tlinx.org>
Date:   Thu, 27 May 2021 03:05:45 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: attempt to restore file dumps, but no files selectable in interactive
 mode
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I wanted to restore a few files from a lvl9 dump but am unable to find any
files in the dump [file].

I dump out the list of files in the dump and I see what looks like all 
the files
but under 'orphanage/256.0/'.

 From there it looks like what would be the files I'm expecting (it's a 
dump of
a /home partition).

I tried 'cd'ing into the orphanage/256.0, but no go.

Interactively I see nothing in the 2.3G dumpfile.

I'm trying to extract all the files in the dump, but am not sure what
it is doing.  Am getting odd messages for what looks like each file:

xfsrestore: NOTE: ino 573299 salvaging file, placing in 
orphanage/256.0/rpms/tumbleweed/repo/oss/noarch/texlive-musixtnt-2020.182.svn40307-44.1.noarch.rpm

It restored a bunch of files to my test location, and they look like what I
would suspect.

The restore ended with:

xfsrestore: NOTE: ino 8455987333 salvaging file, placing in 
orphanage/256.0/law/mail/.imap/vim/dovecot.index.cache
xfsrestore: WARNING: unable to rmdir /home/Ishtar/home/home/orphanage: 
Directory not empty
xfsrestore: restore complete: 568 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /backups/ishtar/home/home-210521-9-0430.dump OK 
(success)
xfsrestore: Restore Status: SUCCESS

It looks like the files I want are among the restored, but why are all 
of them
under 'orphanage/256.0'?

It definitely prevents me from restore single files....which is a pain, but
at least, it _appears_, the files I wanted might be there...

Ideas?

kernel 5.9.0


Not sure how to print out the version of xfsrestore -- neither --version 
nor -V work.


-linda


