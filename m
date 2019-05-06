Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfEFSTb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 14:19:31 -0400
Subject: Re: [PATCH] xfsdump: (style) remove spaces in front of
 commas/semicolons
References: <20190506115212.9876-1-jtulak@redhat.com>
 <20190506131418.GA48302@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <206e3aba-2b44-bbda-502b-53d70ed27a4d@sandeen.net>
Date: Mon, 6 May 2019 13:19:28 -0500
MIME-Version: 1.0
In-Reply-To: <20190506131418.GA48302@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 5/6/19 8:14 AM, Brian Foster wrote:
> On Mon, May 06, 2019 at 01:52:12PM +0200, Jan Tulak wrote:
>> Hi guys,
>>
>> Here is another xfsdump cleaning patch.
>> Git stat: 31 files changed, 206 insertions(+), 206 deletions(-)
>>
>> Cheers,
>> Jan
>>
>> ---
>>
>> Turn all the "x , y , z" into "x, y, z" and "for (moo ; foo ; bar)"
>> to "for (moo; foo; bar)".
>>
>> When doing a clean build, no new warning is produced or existing one
>> removed.
>>
>> Changed macros:
>> __arch__swab[16,32,64] in include/swab.h.
>>
>> Created by this script:
>> *****
>> set -euo pipefail
>>
>> find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
>>     $0 = gensub(/^([^"]*[^[:space:]][^"]*) ,/, "\\1,", "g")
>>     $0 = gensub(/^([^"]*[^[:space:]][^"]*) ;/, "\\1;", "g")
>>     $0 = gensub(/^(.*[^[:space:]].*) ,([^"]*)$/, "\\1,\\2", "g")
>>     $0 = gensub(/(.*[^[:space:]].*) ;([^"]*)$/, "\\1;\\2", "g")
>> }; {print }' {} \;
>> *****
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
> ...
>> diff --git a/common/drive.c b/common/drive.c
>> index b01b916..a3514a9 100644
>> --- a/common/drive.c
>> +++ b/common/drive.c
> ...
>> @@ -3088,7 +3088,7 @@ prepare_drive(drive_t *drivep)
>>  	 * if not present or write-protected during dump, return.
>>  	 */
>>  	maxtries = 15;
>> -	for (try = 1 ; ; sleep(10), try++) {
>> +	for (try = 1;; sleep(10), try++) {
> 
> FWIW, I think the spaces actually make sense in contexts like the above
> where we've intentionally left a statement empty. Without the space this
> kind of looks like a double semicolon, which is slightly misleading at a
> glance.

Haha, yikes, how DOES one make this prettier w/o just killing it
with fire? ;)

-Eric
