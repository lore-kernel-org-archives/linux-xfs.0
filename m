Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176DDC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 12:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhLGMZF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:25:05 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21823 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbhLGMZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 07:25:04 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1638879688; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DmhyS37EY4gg8ynA9LqoF7OtNopqtsiwgIJVDkrLq5ir8Qnxt8HitGQpDd0T5K6VNdqhoxQ5uR0sKuU0TgcEEebsnN2idS6ewPrHVpNpb61FBC91SkRr/3TT3bm6KGZpR7vTMjF0Tp/OJhtYG4U95wIDobwx+UzeFicqaNDY6uk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1638879688; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=cbF+BcntCTixZ+jps2HAAvtfZEGBjD+lOlw14UnUVTs=; 
        b=Eq56ZtH59WRl3JCJTLkDIwq9xTEDNQjhkKN4pho+/jAZOTDkcYyzX9v2sVtGHmQX9u1UGzb6zr+V6V7OYaPBRYwbKT/kXpLqeN0opfycN6qIGEN1//R1HrBmdcmklPAFWvsl4IXXqyS0mKH3nwcOAaDa3cGmS0sGF0sQV7bF/nU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (p5de0b257.dip0.t-ipconnect.de [93.224.178.87]) by mx.zoho.eu
        with SMTPS id 1638879686594857.1580270438393; Tue, 7 Dec 2021 13:21:26 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Message-ID: <20211207122110.1448-1-bage@debian.org>
Subject: [PATCH v2 0/1] debian: Resend .gitcensus change
Date:   Tue,  7 Dec 2021 13:21:09 +0100
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a resend with the Reviewed-by tag collected.
I guess this was not integrated because the first version had one
more patchcthat ended being replaced by a different patch.

Changelog:
 v2: Drop 2nd patch that was reworked by Darrick.

Bastian Germann (1):
  debian: Generate .gitcensus instead of .census (Closes: #999743)

 debian/rules | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.34.1


