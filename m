Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14560 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdECLDj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 May 2017 07:03:39 -0400
Message-ID: <1493809233.30052.1.camel@linux.intel.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from
 libnvdimm
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 03 May 2017 14:00:33 +0300
In-Reply-To: <CAOQ4uxh4Ysg9Q_K2sK9zefvid3hvzswDKxSa-QTN9_D0fAWvyQ@mail.gmail.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
         <1493802823.4154.3.camel@linux.intel.com>
         <CAOQ4uxh4Ysg9Q_K2sK9zefvid3hvzswDKxSa-QTN9_D0fAWvyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>

On Wed, 2017-05-03 at 13:05 +0300, Amir Goldstein wrote:
> On Wed, May 3, 2017 at 12:13 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Tue, 2017-05-02 at 23:19 +0300, Amir Goldstein wrote:
> > > We need a helper for VFS to check if struct super_block field
> > > s_uuid
> > > was filled by the filesystem, before consumers can use it.
> > > 
> > > The libnvdimm code already has a private helper to check if uuid
> > > is
> > > null
> > > and the helper name is not using a private namespace prefix, which
> > > prevents us from using the same helper name as a common function.
> > > 
> > 
> > Hmm...
> > Have you checked my branch here:
> > https://bitbucket.org/andy-shev/linux/branch/topic%2Fuuid
> > ?
> > 
> 
> Hi Andy,
> 
> No I have not seen your patches. When do you plan to post them?

Some of them had been sent in different series recently and ~year ago.
Some need to be polished and tested first.

So, somewhere in the future for sure.

> > Probably not.
> > I have number of patches to make UUID API used kernel wide.
> > 
> 
> That looks nice, but I see you did not get to converting many other
> users that represent uuid as u8[16], like libnvdimm, bluetooth,
> various filesystems and users of sb->s_uuid (IMA).

Yes, my main goal is to make ACPI glue layer to use UUID API.

I didn't touch and I won't touch filesystems since it's a huge area
which I have no knowledge of.

For the rest I might be interested to do, but have no time.

> 
> > ...including helpers for null UUID check:
> > https://bitbucket.org/andy-shev/linux/commits/79029ebe2c32830f82effc
> > 0f0b
> > 62cce2b6eb7fdb?at=topic/uuid
> > 
> 
> I wouldn't mind using is_null_uuid_le(sb->s_uuid) myself and that is
> how
> I implemented the test in my current patch set, but I can hear the
> voices of
> those saying that there should be a 'natural' helper uuid_is_null(u8
> *) for the
> users that represent uuid as u8[16] (i.e. filesystems and sb->s_uuid).

u8 * doesn't represent UUID as a type.
Perhaps we need to reflect this in the name of the function somehow.

> Also, I suggest naming your helpers uuid_{le|be}_is_null() to maintain
> the uuid_* naming convention with other helpers you added to uuid.h.

I'm open to a name that satisfies most of us. So, no objections here.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
