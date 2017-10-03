Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:38444 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdJCUlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.1710032230450.17517@jbgna.fhfr.qr>
References: <20171003185313.1017-1-mcgrof@kernel.org> <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd> <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
 <20171003202121.GB23521@amd> <nycvar.YFH.7.76.1710032230450.17517@jbgna.fhfr.qr>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 3 Oct 2017 22:41:02 +0200
Message-ID: <CAJZ5v0gSqZAKXHD0DBCv2967LddgNtpC5NTs6UvO8C=q5p2VKw@mail.gmail.com>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jiri Kosina <jikos@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, bart.vanassche@wdc.com, ming.lei@redhat.com, Ted Ts'o <tytso@mit.edu>, darrick.wong@oracle.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, linux-fsdevel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Todd Brandt <todd.e.brandt@linux.intel.com>, nborisov@suse.com, Jan Kara <jack@suse.cz>, martin.petersen@oracle.com, Oliver Neukum <ONeukum@suse.com>, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, Linux PM <linux-pm@vger.kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Oct 3, 2017 at 10:38 PM, Jiri Kosina <jikos@kernel.org> wrote:
> On Tue, 3 Oct 2017, Pavel Machek wrote:
>
>> > This point I don't understand. What exactly do you mean?
>>
>> Hibernation:
>>
>> We freeze, do system snapshot, unfreeze, and write image to
>> disk.
>
> Where/why do you unfreeze between creating the snapshot and writing it
> out?

We do not unfreeze then.
