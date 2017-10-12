Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:53093 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdJLDoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 23:44:03 -0400
Received: by mail-oi0-f53.google.com with SMTP id c202so6353300oih.9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 20:44:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ij9E9tXPLqp6cUAY3dJzh7OS+yPsVDME50xSvQPLpStA@mail.gmail.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012012131.GD21978@ZenIV.linux.org.uk> <CAPcyv4jr4atxCqFW_337Sguu8LswVgjsJVOd65n4RODttX9cxQ@mail.gmail.com>
 <CAPcyv4ij9E9tXPLqp6cUAY3dJzh7OS+yPsVDME50xSvQPLpStA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 20:44:01 -0700
Message-ID: <CAPcyv4gKXgq5=MNMSk3idk0_jqfPR1Eh-NwQYCAfYWDjEqYNcA@mail.gmail.com>
Subject: Re: [PATCH v9 2/6] fs, mm: pass fd to ->mmap_validate()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Wed, Oct 11, 2017 at 7:17 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Oct 11, 2017 at 6:28 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Wed, Oct 11, 2017 at 6:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Wed, Oct 11, 2017 at 05:47:18PM -0700, Dan Williams wrote:
>>>> The MAP_DIRECT mechanism for mmap intends to use a file lease to prevent
>>>> block map changes while the file is mapped. It requires the fd to setup
>>>> an fasync_struct for signalling lease break events to the lease holder.
>>>
>>> *UGH*
>>>
>>> That looks like one hell of a bad API.  You are not even guaranteed that
>>> descriptor will remain be still open by the time you pass it down to your
>>> helper, nevermind the moment when event actually happens...
>>
>> What am I missing, fcntl(F_SETLEASE) seems to follow a similar pattern?
>
> Ugh, so I think the difference with F_SETLEASE is that the lease ends
> when the fd is closed. In the mmap case the lease follows the lifetime
> of the vma. I'll rethink this interface...

I'm not seeing a lot of good options outside of documenting that if
you close the fd that is registered with MAP_DIRECT you may still get
SIGIO notifications with si_fd set to the stale fd.
