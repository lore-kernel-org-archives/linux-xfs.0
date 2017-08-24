Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59039 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751168AbdHXTPE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 15:15:04 -0400
Date: Thu, 24 Aug 2017 21:15:02 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170824191502.GT27873@wotan.suse.de>
References: <20170818103932.24607-1-jtulak@redhat.com>
 <20170819010300.GM10621@dastard>
 <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
 <20170820015624.GP10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170820015624.GP10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dmitri Pal <dpal@redhat.com>

On Sun, Aug 20, 2017 at 11:56:24AM +1000, Dave Chinner wrote:
> Let me finish factoring all the code into a set of usable
> structures, then we can start looking at the option table and config
> files from a fresh perspective. This time, we need to come up with a
> clean design and clear direction before any patches are written...

While you're on it, I should mention I ran across a nice feature as part of one
of the libraries I evaluated when considering configuration file parsing. The
library libini_config has a rules checker which allows one to build rules from
yet-another file, it uses ini_rules_read_from_file() to let you pass your
rules, you then use ini_rules_check() to check if the configuration file
applies to rules previously loaded. An example INI file for rules is that
of the upstream SSSD:

https://github.com/SSSD/sssd/blob/master/src/config/cfg_rules.ini

I haven't yet dove too much into this but from what I gather the
validator can be a built-in one or a local one.

A curious thing about our use is we'd want a validator for both configuration
file and command line parameters. But such language above may allow us to
easily specify and handle both.

Food for thought as we're trying to come up with a clean design now.

  Luis
