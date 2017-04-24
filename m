Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46135 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1164869AbdDXFAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 01:00:12 -0400
Date: Mon, 24 Apr 2017 07:00:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170424050010.GD28800@wotan.suse.de>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de>
 <20170309223435.GT17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170309223435.GT17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Fri, Mar 10, 2017 at 09:34:35AM +1100, Dave Chinner wrote:
> On Thu, Mar 09, 2017 at 06:57:51PM +0100, Luis R. Rodriguez wrote:
> > I used reset_opt() and went with "last entry specified wins". From my
> > review the goal of the respecification was to ensure each opt param
> > parsed would not reset a prior set param, a paranoid measure, however
> > this clearly does not work well if we want to allow for "last entry
> > specified wins", or re-use the validators for a config file parsing
> > for a first shot a parsing entries.
> 
> Which is essentially broken, because doing something like:
> 
> -m crc =1 -m reflink=1 -m crc=0
> 
> leaves you with an /invalid config/ because of the respecification
> of -m crc=0 and the order in which options are parsed and verified.
> 
> Indeed, things like block and sector sizes are particularly nasty in
> this respect, because other options can be specified in block or
> sector units. SO things like:
> 
> -s size=4k -b size=1s -s size=512 -d size=1000000s
> 
> were considered valid. respecification of options like this is just
> borken, and even if we take "last specification wins" it still means
> that the block size specification is ambiguous and potentially
> incorrect depending on other options. Hence respecification of
> options is simply not allowed and post-processing of the options
> doesn't change that.

We have to pick an approach and stick with, the above seems sensible.

> i.e., the biggest issue with reusing the existing parsing code for
> the "default config" is that is doesn't just set default values - it
> prevents other options from being used.

Right as per original design.

> IOWs, the config file should
> set the default values in the option table, not set the options
> directly as happens on the command line....

As I respin my patches addressing concerns an issue I see with this is current
semantics for "defaultval" is not that they will be the defaults, but rather
they will be the defaults *iff* the user did specify the option on the command
line but did not provide an explicit value. This for example would not allow
distributions to disable a feature which perhaps is enabled by default in
future versions xfsprogs, or enable one which perhaps is by default disabled.
Even if the config file would have values specified, they will be ignored
unless the user passed a user input value with no value for it.

If this is fine by everyone then great.

  Luis
