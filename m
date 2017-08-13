Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33911 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbdHMCoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Aug 2017 22:44:15 -0400
Received: by mail-yw0-f172.google.com with SMTP id s143so40095419ywg.1
        for <linux-xfs@vger.kernel.org>; Sat, 12 Aug 2017 19:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811100327.GD7064@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz> <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com> <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz> <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 12 Aug 2017 19:44:14 -0700
Message-ID: <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Fri, Aug 11, 2017 at 3:03 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Mon, Aug 07, 2017 at 05:24:08PM -0700, Dan Williams wrote:
>> Does sys_mmap() reject unknown flag values today? I'm either not
>> looking in the right place or it's missing and we'll need some
>> interface/mechanism to check if MAP_SYNC is honored.
>
> It doesn't seem to reject unknown flags.
>
> The lack of flags checking strikes back once more, sigh=E1=B9=AB.

How about MAP_SYNC =3D=3D (MAP_SHARED|MAP_PRIVATE)? On older kernels that
should get -EINVAL, and on new kernels it means SYNC+SHARED.
