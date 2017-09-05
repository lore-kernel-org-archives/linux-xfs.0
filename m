Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36716 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdIENkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 09:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20170905110346.GC8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-11-git-send-email-amir73il@gmail.com> <20170905110346.GC8034@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Sep 2017 16:40:31 +0300
Message-ID: <CAOQ4uxh7qktpbhCOt6YCbZCyWzYptb6MSkzPjMmdyGfETA4new@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] log-writes: add replay-log program to replay
 dm-log-writes target
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 5, 2017 at 2:03 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Aug 30, 2017 at 05:51:42PM +0300, Amir Goldstein wrote:
>> Imported Josef Bacik's code from:
>> https://github.com/josefbacik/log-writes.git
>>
>> Specialized program for replaying a write log that was recorded by
>> device mapper log-writes target.  The tools is used to perform
>> crash consistency tests, allowing to run an arbitrary check tool
>> (fsck) at specified checkpoints in the write log.
>>
>> [Amir:]
>> - Add project Makefile and SOURCE files
>> - Document the replay-log auxiliary program
>>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
...
>> +static int zero_range(struct log *log, u64 start, u64 len)
>> +{
>> +     u64 bufsize = len;
>> +     ssize_t ret;
>> +     char *buf = NULL;
>> +
>> +     if (log->max_zero_size < len) {
>> +             if (log_writes_verbose)
>> +                     printf("discard len %llu larger than max %llu\n",
>> +                            (unsigned long long)len,
>> +                            (unsigned long long)log->max_zero_size);
>> +             return 0;
>> +     }
>> +
>> +     while (!buf) {
>> +             buf = malloc(sizeof(char) * len);
>                                             ^^^^ shouldn't this be bufsize?
>

Yeh, look like is should be...
FYI, zero_range() is  used to emulate DISCARD that
was recorded on a device that supports DISCARD but then
replayed on a device that does not support DISCARD
The only time I tested this scenario is when I replayed lof to /dev/null.

>> +/*
>> + * @log: the log we are manipulating.
>> + * @entry_num: the entry we want.
>> + *
>> + * Seek to the given entry in the log, starting at 0 and ending at
>> + * log->nr_entries - 1.
>> + */
>> +int log_seek_entry(struct log *log, u64 entry_num)
>> +{
>> +     u64 i = 0;
>> +
>> +     if (entry_num >= log->nr_entries) {
>> +             fprintf(stderr, "Invalid entry number\n");
>> +             return -1;
>> +     }
>> +
>> +     if (lseek(log->logfd, log->sectorsize, SEEK_SET) == (off_t)-1) {
>> +             fprintf(stderr, "Error seeking in file: %d\n", errno);
>> +             return -1;
>> +     }
>
> Hmm, we reset the log position to the first log entry by seeking to
> log->sectorsize, shouldn't log->cur_entry be reset to 0 too? Though it
> doesn't make any difference for now, because log_seek_entry() is only
> called at init time, log->cur_entry is 0 anyway. But still, I think it
> should be fixed.
>

True.

> BTW, better to add some comments about the seek, it's not so obvious
> it's seeking off the log super block on first read :)
>
...
>> +
>> +/*
>> + * Basic info about the log for userspace.
>> + */
>> +struct log_write_super {
>> +     __le64 magic;
>> +     __le64 version;
>> +     __le64 nr_entries;
>> +     __le32 sectorsize;
>> +};
>> +
>> +/*
>> + * sector - the sector we wrote.
>> + * nr_sectors - the number of sectors we wrote.
>> + * flags - flags for this log entry.
>> + * data_len - the size of the data in this log entry, this is for private log
>> + * entry stuff, the MARK data provided by userspace for example.
>> + */
>> +struct log_write_entry {
>> +     __le64 sector;
>> +     __le64 nr_sectors;
>> +     __le64 flags;
>> +     __le64 data_len;
>
> This has to match the in-kernel log_write_entry structure, but the
> data_len field is not used in this userspace program, better to add
> comments to explain that.

OK. also should_stop() should strncmp() with data_len instead of strcmp
so there is a use for data_len...

>
>> +};
>> +
>> +#define LOG_IGNORE_DISCARD (1 << 0)
>> +#define LOG_DISCARD_NOT_SUPP (1 << 1)
>> +
>> +struct log {
>> +     int logfd;
>> +     int replayfd;
>> +     unsigned long flags;
>> +     u64 sectorsize;
>> +     u64 nr_entries;
>> +     u64 cur_entry;
>> +     u64 max_zero_size;
>> +     off_t cur_pos;
>
> cur_pos is not used, can be removed?

I think it is best if I used it in patch
("replay-log: add validations for corrupt log entries")
every time I added lseek(log->logfd, 0, SEEK_CUR)
for printing offset in debug logs.
