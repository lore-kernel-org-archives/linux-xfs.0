Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:33672 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbdEPKGn (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Tue, 16 May 2017 06:06:43 -0400
Message-Id: <591AEB51020000780015A128@prv-mh.provo.novell.com>
Date: Tue, 16 May 2017 04:06:41 -0600
From: "Jan Beulich" <JBeulich@suse.com>
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
In-Reply-To: <4dd8c329-2e38-263c-35d4-0756c6cf9e65@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

>>> On 15.05.17 at 18:52, <sandeen@sandeen.net> wrote:
> On 5/15/17 4:22 AM, Jan Beulich wrote:
>> It seems to have improved the situation (on the first system I had
>> the issue on), but leaves me with at least "Operation not permitted"
>> upon init scripts (or me manually) rm-ing (or mv-ing) /var/run/*.pid
>> (or mv-ing even /var/run itself). I'm not sure how worried I need to
>> be, but this surely doesn't look overly healthy yet. The kernel
>> warnings are all gone, though.
> 
> xfs_repair simply makes the filesystem consistent, it doesn't perform
> any other magic.  :)  The corruption we saw was related to incorrect
> flags set on an inode - in some cases flags like immutable which can
> affect access to the file.
> 
> I'm not sure we've made much progress on the root cause of whatever set
> those extra flags*,

Indeed, and that's the primary aspect that worries me, since with
working on the hypervisor or kernel it is going to be unavoidable for
a crash to happen now and then. While I realize chances are low to
find out any useful information for the two past cases of corruption,
do you have any advice on how to collect / preserve necessary
information on a sooner or later to be expected next instance? Isn't
the most likely explanation that the log replay upon next mount has
gone wrong (or the data in the log itself was bogus)?

> but all repair will do is make them sane from a
> filesystem consistency POV, not from an OS operation POV.

Understood.

> Check the files in question with lsattr, and see if there are unexpected
> flags still set.

Indeed I had done this (and the resulting cleanup) before replying.
And yes, some of the initial issues went away with clearing stray i or
a flags. Yet I wasn't able to tie the /var/run problem to any flag
settings. I hope to find time to debug where exactly these errors
are being generated, ideally allowing me to understand how to
correct their cause.

Jan

