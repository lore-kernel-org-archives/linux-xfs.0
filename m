Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PJqZTw219756 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 13:52:35 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D696DAC002
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 11:55:18 -0800 (PST)
Message-ID: <4D68092A.7070608@sgi.com>
Date: Fri, 25 Feb 2011 13:55:22 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: fix bug restricting -f pathname length
References: <1298572850-15408-1-git-send-email-wkendall@sgi.com>
	<1298662057.1990.7054.camel@doink>
In-Reply-To: <1298662057.1990.7054.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 02/25/2011 01:27 PM, Alex Elder wrote:
> On Thu, 2011-02-24 at 12:40 -0600, Bill Kendall wrote:
>> A temporary buffer storing the dump filename (-f) is smaller than
>> the otherwise allowed pathname length. This buffer is used to
>> extract the pathname from additional parameters specified as part
>> of the -f argument. As these parameters are an undocumented and
>> unused extension of the -f argument, simply remove this code.
>> Note that drive_alloc() always dups the given pathname, so
>> 'optarg' is passed directly.
>
> If someone happens to put something starting with a comma
> after the device path name, will it simply fail because
> a device by that name (comma included) won't exist?

xfsdump creates the file if it does not exist, so you would
end up with a comma in the dump filename.

Thanks,
Bill

>
> Either way, this looks good.  I'll hold off a bit before
> taking this in, in case someone else wants a chance to
> review.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>> ---
>>   common/drive.c |   18 +-----------------
>>   1 files changed, 1 insertions(+), 17 deletions(-)
>>
>> diff --git a/common/drive.c b/common/drive.c
>> index f184afa..227fecd 100644
>> --- a/common/drive.c
>> +++ b/common/drive.c
>> @@ -137,10 +137,6 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
>>   	opterr = 0;
>>   	driveix = 0;
>>   	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
>> -		char optarray[100];
>> -		char *devname;
>> -		char *token;
>> -
>>   		switch ( c ) {
>>   		case GETOPT_DUMPDEST:
>>   			if ( ! optarg || optarg[ 0 ] == '-' ) {
>> @@ -151,21 +147,9 @@ drive_init1( int argc, char *argv[ ], bool_t singlethreaded )
>>   				return BOOL_FALSE;
>>   			}
>>
>> -			/* remove the device name from the rest of the
>> -			 * parameter string. note that strdup malloc()s
>> -			 * a string; important since optarray is an auto.
>> -			 */
>> -			ASSERT( strlen( optarg )<  sizeof( optarray ));
>> -			strncpy( optarray, optarg, sizeof( optarray ));
>> -			optarray[ sizeof( optarray ) - 1 ] = 0;
>> -			if ( ( token = strtok( optarray, "," )) == NULL ) {
>> -				token = optarray;
>> -			}
>> -			devname = strdup( token );
>> -
>>   			/* allocate a drive descriptor
>>   			 */
>> -			drivepp[ driveix ] = drive_alloc( devname, driveix );
>> +			drivepp[ driveix ] = drive_alloc( optarg, driveix );
>>   			driveix++;
>>   			break;
>>   		}
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
