Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:38097 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEQF1D (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Wed, 17 May 2017 01:27:03 -0400
Message-Id: <591BED3402000078000FE8A7@prv-mh.provo.novell.com>
Date: Tue, 16 May 2017 23:27:00 -0600
From: "Jan Beulich" <jbeulich@suse.com>
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
 <591571BC0200007800159165@prv-mh.provo.novell.com>
 <30296667-47d7-8b94-472a-1d4b96120c09@sandeen.net>
 <5915DE47020000780015946C@prv-mh.provo.novell.com>
 <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
 <574ee8c5-71f9-eba5-b779-49be4086b6c8@sandeen.net>
 <59198F810200007800159B81@prv-mh.provo.novell.com>
 <4dd8c329-2e38-263c-35d4-0756c6cf9e65@sandeen.net>
 <591AEB51020000780015A128@prv-mh.provo.novell.com>
 <423e3471-747a-fa44-e313-9e6b8219e9a5@sandeen.net>
In-Reply-To: <423e3471-747a-fa44-e313-9e6b8219e9a5@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

>>> Eric Sandeen <sandeen@sandeen.net> 05/16/17 7:38 PM >>>
>Your first report seems to indicate that a 4.11 kernel crashed, and the
>resulting dirty log was replayed by a 3.12-era distro kernel.  Is that
>the correct sequence of events?

That may have been the case in the second instance of the issue, but
definitely not the first - there I'm sure I did re-run with a 4.11 kernel
right away. But you asking this, yes, the replaying kernel possibly not
mattering may suggest it's rather the log writing than the replaying
which has an issue.

Jan

