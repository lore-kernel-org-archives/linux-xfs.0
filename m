Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54844 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbdEPRiK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 May 2017 13:38:10 -0400
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
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <423e3471-747a-fa44-e313-9e6b8219e9a5@sandeen.net>
Date: Tue, 16 May 2017 12:38:08 -0500
MIME-Version: 1.0
In-Reply-To: <591AEB51020000780015A128@prv-mh.provo.novell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-xfs@vger.kernel.org

On 5/16/17 5:06 AM, Jan Beulich wrote:
>> I'm not sure we've made much progress on the root cause of whatever set
>> those extra flags*,

> Indeed, and that's the primary aspect that worries me, since with
> working on the hypervisor or kernel it is going to be unavoidable for
> a crash to happen now and then. While I realize chances are low to
> find out any useful information for the two past cases of corruption,
> do you have any advice on how to collect / preserve necessary
> information on a sooner or later to be expected next instance? Isn't
> the most likely explanation that the log replay upon next mount has
> gone wrong (or the data in the log itself was bogus)?

About all I can suggest is to get an xfs_metadump as soon as any new
problem shows up, if it does.


Your first report seems to indicate that a 4.11 kernel crashed, and the
resulting dirty log was replayed by a 3.12-era distro kernel.  Is that
the correct sequence of events?

-Eric
