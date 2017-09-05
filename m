Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:38859 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdIELln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 07:41:43 -0400
MIME-Version: 1.0
In-Reply-To: <20170905110737.GD8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-13-git-send-email-amir73il@gmail.com> <20170905110737.GD8034@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Sep 2017 14:41:42 +0300
Message-ID: <CAOQ4uxhFC5BM0U9YGyQ9VLAEtiM4wZugtpmv4WtQ-vO4A17HaQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] replay-log: add support for replaying ops in
 target device sector range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 5, 2017 at 2:07 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Aug 30, 2017 at 05:51:44PM +0300, Amir Goldstein wrote:
>> Using command line options --start-sector and --end-sector, only
>> operations acting on the specified target device range will be
>> replayed.
>>
>> Single vebbose mode (-v) prints out only replayed operations.
>> Double verbose mode (-vv) prints out also skipped operations.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  src/log-writes/log-writes.c | 33 +++++++++++++++++++++++++++++++--
>>  src/log-writes/log-writes.h |  2 ++
>>  src/log-writes/replay-log.c | 31 +++++++++++++++++++++++++++++++
>>  3 files changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
>> index ba66a5c..d832c2a 100644
>> --- a/src/log-writes/log-writes.c
>> +++ b/src/log-writes/log-writes.c
>> @@ -119,6 +119,24 @@ int log_discard(struct log *log, struct log_write_entry *entry)
>>
>>  /*
>>   * @log: the log we are replaying.
>> + * @entry: entry to be replayed.
>> + *
>> + * @return: 0 if we should replay the entry, > 0 if we should skip it.
>> + *
>> + * Should we skip the entry in our log or replay onto the replay device.
>> + */
>> +int log_should_skip(struct log *log, struct log_write_entry *entry)
>> +{
>> +     if (!entry->nr_sectors)
>> +             return 0;
>> +     if (entry->sector + entry->nr_sectors < log->start_sector ||
>> +         entry->sector > log->end_sector)
>
> Seems values from entry can't be used directly, need le64_to_cpu first I
> think.
>
>> +             return 1;
>> +     return 0;
>> +}
>> +
>> +/*
>> + * @log: the log we are replaying.
>>   * @entry: where we put the entry.
>>   * @read_data: read the entry data as well, entry must be log->sectorsize sized
>>   * if this is set.
>> @@ -137,6 +155,7 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
>>       char *buf;
>>       ssize_t ret;
>>       off_t offset;
>> +     u64 skip = 0;
>
> int skip? and log_should_skip returns int too.
>

Right. Thanks

FYI, this is also a debugging option.
I used to to replay operations on a given range that was different between
good and bad buffers to narrow down the suspects.
