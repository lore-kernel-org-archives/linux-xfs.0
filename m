Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25401 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdFVEkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 00:40:39 -0400
From: Todd Chester <ToddAndMargo@zoho.com>
Subject: RFE: interrupted restore sessions
Message-ID: <d09f0f23-d8be-0e33-ce74-3b77342b7a6d@zoho.com>
Date: Wed, 21 Jun 2017 21:40:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Dear XFS Developers,

The Red Hat bugzilla staff asked me to post this kind of
stuff "upstream".   I hope I have the right place.

http://rpm.pbone.net/index.php3/stat/26/dist/95/size/857409/name/xfsdump-3.1.4-1.el7.src.rpm

Request for Enhancement (RFE):

Would one of our intrepid heroes please consider implementing
the following RFE for me?

When you have to use xfsrestore, you have usually lost something
and are typically under a lot of stress.  You do not need to
contend with other mysteries to solve/troubleshoot to get
your restore to work.  (When it happened to me, I almost
had a heart attack.)

When xfsrestore find a "interrupted restore sessions", please prompt the 
user to correct the situation, if he says "yes", correct the problem and 
continue with the restore.

This will greatly cut down on the panic/confusion the user experiences 
when they encounter an "interrupted restore session".


I sincerely appreciate your consideration.

Many thanks,
-T

