Return-Path: <SRS0=NVxF=XK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A195C4CECC
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 12:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2C8214C6
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 12:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGjdb0oR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfIOMoR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Sep 2019 08:44:17 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:46859 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfIOMoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Sep 2019 08:44:16 -0400
Received: by mail-lf1-f41.google.com with SMTP id t8so25284405lfc.13
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2019 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pNtjcXHhpcuAME7H1OmW5QzSvs05ZjD0K2wsTIsxBq4=;
        b=AGjdb0oRe9IsFb0AWkNKbIYeRD79wi2r4p++QcTvt9R0dZWhjf9Mj4VGLuy0VREnZ8
         KNlk5RYf3aD26+fary5eecDe9vbBdOalCOaAT/JumSQy9mquqjZqaxg9HBIKUk6AEkjI
         Z2yeV4nvlcyyBwxhYyDFSf4VheNqr9gYl71tQg5DZdNEGiZH8v+Wm6mPe3j3naeHYM/3
         wFlUOIK0nbrJveCXUxGfyHhrL+UjL/12FfJUxT62iL8xM3mIQgt6rUeKk60EHdVKJolT
         0mzjW392wjjkPgSq1Rwfay5SuoZtwJKjniWGcgMaZ349popijiTdQMaYhfzOIAMSbPkC
         i4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pNtjcXHhpcuAME7H1OmW5QzSvs05ZjD0K2wsTIsxBq4=;
        b=r4mZBbRK0tDbg1cgWAUc8m4TpeX1U58xkh1TIdukrSICiq1yoDxmHUGqbjxz0nJQII
         fd+WSNqiGlh4I5rCTEkm4OESX3vF/0wqvA7u+a49KcMKWjYAQVP6kCgPRMvBHbn9ZThe
         AIxP1izKdres5ZJobtz3SOQZSh+tWS0VBRejKNSkbWKD5x5XWFZ2b/X5HriwXvOsb5FV
         kHAadFmFRVaUHmya8bXYN9ukhkM0RyiK9VbFlLkgpwBLqtsSqKnOzx97rX9ASv+8rnN+
         ouoGmPPRVBllqq+qVsWdsENjMC/pujMA6qnwhs8BpsT8VkYPEEO4HaLvB8UdiuAqjgxz
         +Gfw==
X-Gm-Message-State: APjAAAU9PEF6KUOdyHYDMSu/DA+xb/tpdvbkIpLP0XeyilQtg0gN3Hx8
        GHV8Bq9bL7r2S4b0vhoEOnowbbcG
X-Google-Smtp-Source: APXvYqwS8+TI0LkckfhmGCOeY6Yj9Jc6BI8URvF6P7F3m6k87RnGeQg/a53pAYQIH6Nfz5eOd97mxQ==
X-Received: by 2002:a19:5d53:: with SMTP id p19mr14294529lfj.109.1568551454301;
        Sun, 15 Sep 2019 05:44:14 -0700 (PDT)
Received: from amb.local (31-179-17-47.dynamic.chello.pl. [31.179.17.47])
        by smtp.gmail.com with ESMTPSA id z21sm7563702ljn.100.2019.09.15.05.44.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 05:44:13 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err == 2' failed.
Message-ID: <7097d965-1676-a70e-56c7-b6cf048057f5@gmail.com>
Date:   Sun, 15 Sep 2019 14:44:09 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hello.

xfsprogs 5.2.1 and:

disconnected dir inode 9185193405, moving to lost+found
disconnected dir inode 9185193417, moving to lost+found
disconnected dir inode 9185194001, moving to lost+found
disconnected dir inode 9185194004, moving to lost+found
disconnected dir inode 9185194010, moving to lost+found
disconnected dir inode 9185194012, moving to lost+found
disconnected dir inode 9185194018, moving to lost+found
disconnected dir inode 9185194027, moving to lost+found
disconnected dir inode 9185205370, moving to lost+found
disconnected dir inode 9185209007, moving to lost+found
corrupt dinode 9185209007, (btree extents).
Metadata corruption detected at 0x449621, inode 0x2237b2aaf
libxfs_iread_extents
xfs_repair: phase6.c:1129: mv_orphanage: Assertion `err == 2' failed.
Aborted



# grep -A1 -B1 9185209007 log
entry ".." at block 0 offset 80 in directory inode 9185141346 references
non-existent inode 6454491396
entry ".." at block 0 offset 80 in directory inode 9185209007 references
free inode 62881485764
entry ".." at block 0 offset 80 in directory inode 9185220220 references
free inode 6454492606
--
rebuilding directory inode 9185141346
entry ".." in directory inode 9185209007 points to free inode
62881485764, marking entry to be junked
rebuilding directory inode 9185209007
name create failed in ino 9185209007 (117), filesystem may be out of space
entry ".." in directory inode 9185220220 points to free inode
6454492606, marking entry to be junked
--
disconnected dir inode 9185205370, moving to lost+found
disconnected dir inode 9185209007, moving to lost+found
corrupt dinode 9185209007, (btree extents).
Metadata corruption detected at 0x449621, inode 0x2237b2aaf
libxfs_iread_extents

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
