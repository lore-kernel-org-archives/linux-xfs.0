Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34606 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeCPKUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 06:20:12 -0400
Received: by mail-wm0-f52.google.com with SMTP id a20so2078963wmd.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Mar 2018 03:20:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180315184925.GC4865@magnolia>
References: <20180315175026.34779-1-jtulak@redhat.com> <20180315182850.36783-1-jtulak@redhat.com>
 <20180315184925.GC4865@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 16 Mar 2018 11:19:50 +0100
Message-ID: <CACj3i71yGDXq0SrpsM-VNwVwf=fZUcQi+1ve5kn_wdBmgt7KSA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 7:49 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Mar 15, 2018 at 07:28:50PM +0100, Jan Tulak wrote:
>> +
>> +# get the right return code for fsck
>> +function repair2fsck_code() {
>> +     case $1 in
>> +     0)  return 0 # everything is ok
>> +             ;;
>> +     1)  echo "$NAME error: xfs_repair could not fix the filesystem." 1>&2
>> +             return 4 # errors left uncorrected
>> +             ;;
>> +     2)  echo "$NAME error: The filesystem to be checked must not be mounted." 1>&2
>> +             return 4 # it should not me mounted during boot, something is wrong
>
> Sorry I missed this on the first go-round, but repair status 2 means the
> log is dirty, so the admin must mount the fs to try to replay the log or
> run xfs_repair -L to dump the log.  It does not mean that the fs is
> already mounted.
>
> "$NAME error: The filesystem log is dirty, either mount it to recover
> the log.  If that fails, run xfs_repair -L to clear the log."
>

Right, thanks for spotting it. But I wonder if telling the user to
blindly use -L is safe. Maybe something like "run xfs_repair -L (can
be dangerous, refer to manual pages)" would be better.

Jan
